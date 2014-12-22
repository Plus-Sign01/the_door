class WelcomeController < ApplicationController
  def index
  	@projects = Project.where('start_time > ?', Time.zone.now).order(:start_time)
  

  end
end
