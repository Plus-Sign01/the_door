class User < ActiveRecord::Base
	before_destroy :check_all_projects_finished

	has_many :created_projects, class_name: 'Project', foreign_key: :owner_id, dependent: :nullify

	has_many :participations, dependent: :nullify
	has_many :participation_projects, through: :participantions, source: :project
	def self.find_or_create_from_auth_hash(auth_hash)
		provider = auth_hash[:provider]
		uid = auth_hash[:uid]
		nickname = auth_hash[:info][:nickname]
		image_url = auth_hash[:info][:image]

		User.find_or_create_by(provider: provider, uid: uid) do |user|
           user.nickname = nickname
           user.image_url = image_url
       end
   end





	private
	 def check_all_projects_finished
	 	now = Time.zone.now
	 	if created_projects.where(':now < end_time', now: now).exists?
	 		errors[:base] << '公開中の未終了プロジェクトが存在します。'
	 	end
	 	if participating_projects.where(':now < end_time', now: now).exists?
	 		errors[:base] << '未終了の参加プロジェクトが存在します'
	 	end
	 	errors.blank?
	 end
	 

end