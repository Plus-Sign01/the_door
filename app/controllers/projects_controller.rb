class ProjectsController < ApplicationController
	before_action :authenticate, expect :show

	def show 
		@project = Project.find(params[:id])
		@participation = current_user && current_user.participations.find_by(project_id: params[:id])
		@participation = @project.participations.includes(:user).order(:created_at)

	end
	def new
		@project = current_user.created_projects.build
	end

	def create
		@project = current_user.created_projects.build(project_params)
		if @project.save
			flash[:success] = "Welcome to the The Door"
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
		params.require(:project).permit(:name, :place, :project_image, :project_image_cache, :remove_project_image, :content, :start_time, :end_time)
	end
end


end
