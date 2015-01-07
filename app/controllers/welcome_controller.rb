class WelcomeController < ApplicationController
	PER = 10
  def index
    #@projects = Project.page(params[:page]).per[PER].
     #where('start_time > ?', Time.zone.now).order(:start_time)
     @projects = Project.all

    end




 private

  
  def search_params
  	params.require(:q).permit(:name_cont, :start_time_gteq)
  rescue
  	{ start_time_gteq: Time.zone.now }
  end
end


