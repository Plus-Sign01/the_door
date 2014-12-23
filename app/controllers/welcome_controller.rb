class WelcomeController < ApplicationController
	PER = 10
  def index
  	@q = Project.page(params[:page].per(PER).order(:start_time).search(search_params)
  		@project = @q.result(distinct: true)

  

  end
  def search_params
  	params.require(:q).permit!
  rescue
  	{ start_time_gteq: Time.zone.now }
  end
end
