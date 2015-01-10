class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  
 devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, :lockable, :confirmable

	before_destroy :check_all_projects_finished

	has_many :created_projects, class_name: 'Project', foreign_key: :owner_id, dependent: :nullify

	has_many :participations, dependent: :nullify
	has_many :participation_projects, through: :participantions, source: :project

	def self.find_for_facebook_oauth(auth)
		user = User.where(provider: auth.provider, uid: auth.uid).first

		unless user
			user = User.create( name:     auth.extra.raw_info.name,
				                provider: auth.provider,
				                uid:      auth.uid,
				                email:    auth.info.email,
				                token:    auth.credentials.token,
				                password: Devise.friendly_token[0.20] )
		end
			return user
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