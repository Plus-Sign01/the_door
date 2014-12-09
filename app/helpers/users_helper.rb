module UsersHelper
	def gravatar_for(user,options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravater_url = "https://secure.gravatar.com/avatar/#{gravater_id}?s=#{size}"
		image_tag(gravatar_url,alt: user.name, class: "gravater")
	end
end


