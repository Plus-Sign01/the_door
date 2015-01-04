module ApplicationHelper
	def url_for_facebook(user)
		"https://facebook.com/#{user.nickname}"
	end
end
