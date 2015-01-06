class Welcome < ActiveRecord::Base
	def self.search(search)
		if search
			Project.where(['name LIKE ?', "%#{search}"])
		else
			Project.all
		end
	end
	
end
