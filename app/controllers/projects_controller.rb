class ProjectsController < ApplicationController
	before_action :authenticate, expect :show
	
	def show 
		@project = Project.find(params[:id])
	end
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
	def edit
	@project = current_user.created_projects.find(params[:id])

	end
	def update
		@project = current_user.created_projects.find(parmas[:id])
		if @project.update(project_params)
			redirect_to @project, notice: '更新しました'
		else
			render :edit
		end
	end
	def destroy
		@project = current_user.created_projects.find(params[:id])
		@project.destroy!
		redirect_to root_path, notice: '削除しました'
	end
	


	private
	def project_params
		params.require(:project).permit(:name, :place, :content, :start_time, :end_time)
	end
end


end
