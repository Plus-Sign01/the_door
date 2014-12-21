class ProjectsController < ApplicationController
	before_action :authenticate
	def new
		@project = current_user.created_projects.build
	end

	def create
		@project = current_user.created_projects.build(project_params)
		if @project.save
			redirect_to @project, notice: '作成しました'
		else
			render :new
		end
	end
	private
	def project_params
		params.require(:project).permit(:name, :place, :content, :start_time, :end_time)
	end
end


end
