class ParticipationsController < ApplicationController
	before_action :authenticate
	def new
		raise ActionController::RoutingError, 'ログイン状態で ParticipationsController#new にアクセス'
	end
	def create
		participation = current_user.participations.build do |t|
			t.project_id = params[:project_id]
			t.comment = params[:participation][:comment]
		end
		if participation.save
			flash[:notice] = 'プロジェクトに応募しました'
			head 201
		else
			render json: { messages: participation.errors.full_messages }, status: 422
		end
	end
	def destroy
		participation = current_user.participations.find_by!(project_id: params[:project_id])
		participation.destroy!
		redirect_to project_path(params[:project_id]), notice: 'このプロジェクトの参加をキャンセルしました'
	end


end
