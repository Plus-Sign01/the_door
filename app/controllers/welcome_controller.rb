class WelcomeController < ApplicationController
	PER = 10
  def index
  	@q = Project.page(params[:page]).per(PER).order(:start_time).search(search_params)

  	@projects = @q.result
  	 


    end




 private

  
  def search_params
  	params.require(:q).permit(:name_cont, :start_time_gteq)
  rescue
  	{ start_time_gteq: Time.zone.now }
  end
end

