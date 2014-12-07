class ApplicationController < BaseController
  include CampaignControllerConcern

  protect_from_forgery
  before_filter :basic_auth if Rails.env.staging? || Rails.env.qa?
  before_filter :set_conversion_source, if: -> { request.format.html? }
  before_filter :check_one_time_login
  before_filter :set_tracking_code
  before_filter :set_locale
  before_filter :set_olark_config
  after_filter  :log_to_td  # use after_filter to avoid logging redirection
  after_filter :invoke_delayed_job if Rails.env.development? # to the same environment as the production
  before_filter :always_save_access_log
  layout :set_layout

  helper :nav_link

  rescue_from CanCan::AccessDenied do |exception|
    message = exception.message == t('unauthorized.default') ? nil : exception.message
    access_denied message
  end

  rescue_from ActionController::RedirectBackError do |exception|
    redirect_to root_path
  end

  # Override authenticate_user! defined by Devise as it redirects to the root path on failure,
 # while we want to keep the user at the same page and login.
  def authenticate_user!(opts = {})
    access_denied unless user_signed_in?
  end

  def access_denied(message = nil)
    message ||= user_signed_in? ? t('app.access_denied') : t('app.login_required')
    if request.xhr?
      render json: message, status: :forbidden
    else
      @message = message
      render "shared/access_denied"
    end
  end

  def supported_locales
    %w(en ja)
  end

  def set_locale
    if user_signed_in? && supported_locales.include?(current_user.locale)
      locale = current_user.locale
    else
      http_locale = extract_locale_from_accept_language_header
      locale = [cookies[:locale], http_locale, 'ja'].select { |locale| locale.in? supported_locales }.first
    end
    I18n.locale = locale
    cookies.permanent[:locale] = { value: locale, domain: :all }
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", status: :not_found, layout: nil }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def redirect_to_with_moved_permanently(options = {}, response_status = {})
    response_status.reverse_merge!(status: :moved_permanently)
    redirect_to_without_moved_permanently(options, response_status)
  end
alias_method_chain :redirect_to, :moved_permanently

  protected
  def current_company
    @current_company ||= current_user.try(:current_job).try(:company)
  end
  helper_method :current_company

  def current_job
    @current_job ||= current_user.try(:current_job)
  end
  helper_method :current_job

  def gmail_job
    current_user.jobs.where(company_id: session[:gmail_ref_company_id]).first || current_job
  end
  helper_method :gmail_job

  def current_country
    @current_country ||= user_signed_in? ? current_user.current_country : I18n.locale == :ja ? :japan : :united_states
  end
  helper_method :current_country

  def find_company
    @company = Company.find_by_name_or_id(params[:id])
  end

  def set_user
    @user = current_user
  end

  def set_conversion_source
    return if !request.get? || is_internal_referer_page
    return if referer_host == 'widget.wantedly.com'
    session[:conversion_referer] = request.referer.try(:slice, 0, 255)
    session[:conversion_referer_host] = referer_host.try(:slice, 0, 255)
    session[:conversion_utm_source] = params[:utm_source].try(:slice, 0, 255)
    session[:conversion_utm_medium] = params[:utm_medium].try(:slice, 0, 255)
    session[:conversion_utm_campaign] = params[:utm_campaign].try(:slice, 0, 255)
    session[:conversion_updated_at] = Time.now
  end

  # Public: Set tracking code as cookie
   #
  # To track unique users, set unique key as cookie.
  #
  # Returns nothing
  def set_tracking_code
    cookies[:tracking_code] ||= { value: generate_tracking_code, domain: :all }
  end

  def start_new_client_signup(inquiry)
    session[:inquiry_id] = inquiry.id
  end

  def end_new_client_signup
    session.delete(:inquiry_id)
  end

  def new_client_signup?
    !!session[:inquiry_id]
  end

  def current_inquiry
    new_client_signup? ? ClientInquiry.find(session[:inquiry_id]) : nil
  end
  helper_method :current_inquiry

  def is_iphone?
    request.mobile && request.mobile.iphone?
  end
  helper_method :is_iphone?

  def is_android?
    request.mobile && (request.mobile.android? || request.mobile.androidtablet?)
  end
  helper_method :is_android?

  def ads_enabled?
    ENV["ADS_ENABLED"].present? && !ENV["ADS_ENABLED"].downcase.in?(["false", "no", "disable"])
  end
  helper_method :ads_enabled?

  def ab_test_init(group, variation, user = nil)
    AbTest.init(user || current_user, cookies[:tracking_code], group, variation) if ENV['LIBRATO_USER'].present? && ENV['LIBRATO_TOKEN'].present?
  end

  def ab_test_track(moment, user = nil)
    return if ENV['LIBRATO_USER'].blank? || ENV['LIBRATO_TOKEN'].blank?
    user ||= current_user
    test = AbTest.track(moment, user.try(:id), cookies[:tracking_code])
    test
  end

  def ab_test_variation(group)
    AbTest.fetch(current_user, cookies[:tracking_code], group).try(:variation)
  end
  helper_method :ab_test_variation

  protected
  # Override this in controller subclasses
  def default_layout
    "application"
  end

  def set_layout
    return default_layout
  end

  def mobile_layout
    is_mobile? ? 'mobile' : set_layout
  end

  def always_save_access_log
    if request.get? && current_user.present?
      if cookies[:user_accessed_at].blank? || !(cookies[:user_accessed_at].to_date == Date.today)
        time_now = Time.now
        cookies[:user_accessed_at] = { value: time_now }
        user_detail = current_user.detail
        user_detail.accessed_at = time_now
        user_detail.save
      end
    end
  end

  private
  def extract_locale_from_accept_language_header
    return nil  if !request.env['HTTP_ACCEPT_LANGUAGE']
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def job_options
    @job_options ||= current_user.selectable_jobs.except_for_current_job.includes({ company: :avatar }, :employee) if user_signed_in?
  end
  helper_method :job_options

  def current_notifications
    @current_notifications ||= current_job.notifications.includes(:target) if user_signed_in?
  end
  helper_method :current_notifications

  def individual_notifications
    @individual_notifications ||= current_user.individual_job.notifications.includes(:target) if user_signed_in?
  end
  helper_method :individual_notifications

  def bookmarked_projects
    @bookmarked_projects ||= if user_signed_in?
                               Project.unscoped { current_user.bookmarked_projects }
                             else
                               Project.unscoped { Project.find(session[:bookmarked_project_ids].to_a) }
                             end
  end
  helper_method :bookmarked_projects

  # Internal: Generate tracking code
  #
  # generate a key to track unique users on page view.
  #
  # Returns string
  def generate_tracking_code
    Digest::SHA1.hexdigest "huntrtr@ck1ngc0de#{Time.now}+#{request.remote_ip.to_s}:#{rand.to_s}"
  end

  def canonical_url(obj)
    case obj
    when Project
      url = project_url(obj)
    when Company
      url = company_url(obj)
    when User
      url = user_url(obj)
    when ProjectList
      url = project_list_url(obj)
    when Staffing
      url = project_staffing_url(obj.project_id, obj.id)
    when HistorySetting
      url = user_history_path(user_id: obj.user_id)
    when String
      url = obj
    when Post
      url = company_post_url(obj.company, obj)
    else
      url = Settings.service.url
    end
    url.gsub('http://', 'https://')
  end
  helper_method :canonical_url

  def redirect_after_connect_registration
    redirect_to(session.delete(:path_after_connect_registration) || root_path)
  end

  def after_sign_in_path_for(resource)
    session.delete(:path_after_sign_in) || root_path
  end

  def after_sign_out_path_for(resource)
    session.delete(:path_after_sign_out) || request.referer || root_path
  end

  def save_path_after_sign_in(path = nil)
    session[:path_after_sign_in] = path || request.fullpath
  end

  def check_one_time_login
    if session[:one_time_login] && !ENV["FACEBOOK_INCIDENT"]
      session.delete(:one_time_login)
      session[:path_after_sign_out] = root_path
      redirect_to destroy_user_session_path
    end
  end

  def invoke_delayed_job
    current_locale = I18n.locale
    I18n.locale = I18n.default_locale

    Delayed::Job.ready_to_run("pid:#{Process.pid}", Delayed::Worker.max_run_time).limit(10).each do |dj|
      begin
        dj.invoke_job
        dj.destroy
        logger.info "#{dj.name} completed"
      rescue => excption
        dj.last_error = "#{excption.message}\n#{excption.backtrace.join("\n")}"
        dj.fail!
        logger.error "#{dj.name} failed"
        logger.error "Exception: #{excption}"
      end
    end
  ensure
    I18n.locale = current_locale
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USERNAME"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def set_olark_config
    @olark_welcome_title = "お問い合わせはこちら"
    @olark_chatting_title = "お問い合わせはこちら"
    @olark_welcome_message = "あなたのチームもThe Doorを使ってみませんか。ご相談に個別回答します。お電話は080-8352-8602まで"
    @olark_chat_input_text = "お問い合わせ内容をご記入ください"
    @olark_unavailable_title = "お問い合わせはこちら"
    @olark_offline_note_message = "あなたのチームもWantedlyを使ってみませんか。ご相談にメールで個別回答します。お電話は03-5422-9881まで"
    if ["option_inquiries"].include?(params[:controller])
      @olark_welcome_message = "各拡張オプションについてあなたのチームにあった使い方を知りたい方はこちらから。お電話は03-5422-9881まで"
      @olark_chat_input_text = "専門担当者に相談したい内容をどうぞ"
      @olark_offline_note_message = "各拡張オプションについてあなたのチームにあった使い方を知りたい方はこちらから。お電話は03-5422-9881まで"
    elsif ["about"].include?(params[:controller]) && ["list"].include?(params[:action])
      @olark_welcome_title = "ご不明点がありますか？"
      @olark_chatting_title = "ご不明点がありますか？"
      @olark_unavailable_title = "ご不明点がありますか？"
      @olark_welcome_message = "登録前に不明点を解消したい方は、無料説明会にご参加ください。連絡先を記入いただければ、説明会へご案内します。"
      @olark_offline_note_message = "登録前に不明点を解消したい方は、無料説明会にご参加ください。連絡先を記入いただければ、説明会へご案内します。"
    end
  end
end
