Devise.setup do |config|
  OAUTH_CONFIG = YAML.load_file("#{Rails.root}/config/omniauth.yml")[Rails.env].symbolize_keys!

   #https://github.com/mkdynamic/omniauth-facebook
   #https://developers.facebook.com/docs/concepts/login/
  config.omniauth :facebook, OAUTH_CONFIG[:facebook]['key'], OAUTH_CONFIG[:facebook]['secret'], scope: 'email,publish_stream,user_birthday'

  # https://github.com/intridea/omniauth-github
  # http://developer.github.com/v3/oauth/
  # http://developer.github.com/v3/oauth/#scopes
  #config.omniauth :github, OAUTH_CONFIG[:github]['key'], OAUTH_CONFIG[:github]['secret'], scope: 'user,public_repo'

  # https://github.com/zquestz/omniauth-google-oauth2
  # https://developers.google.com/accounts/docs/OAuth2
  # https://developers.google.com/+/api/oauth
  #config.omniauth :google_oauth2, 
#OAUTH_CONFIG[:google]['key'], OAUTH_CONFIG[:google]['secret'], scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/plus.me https://www.google.com/m8/feeds', name: :google

  # https://github.com/mururu/omniauth-hatena
  # http://developer.hatena.ne.jp/ja/documents/auth/apis/oauth
  #config.omniauth :hatena, OAUTH_CONFIG[:hatena]['key'], OAUTH_CONFIG[:hatena]['secret']

  # https://github.com/skorks/omniauth-linkedin
  # https://developer.linkedin.com/documents/authentication
  # https://developer.linkedin.com/documents/profile-fields
  #config.omniauth :linkedin, OAUTH_CONFIG[:linkedin]['key'], OAUTH_CONFIG[:linkedin]['secret'], scope: 'r_basicprofile r_emailaddress r_network',
    #fields: [
      # "id", "first-name", "last-name", "formatted-name", "headline", "location", "industry", "summary", "specialties", "positions", "picture-url", "public-profile-url", # in r_basicprofile
      #{}"email-address",  # in r_emailaddress
     # "connections"  # in r_network
    #]

  # https://github.com/pivotal-sushi/omniauth-mixi
  # http://developer.mixi.co.jp/connect/mixi_graph_api/api_auth/
  #config.omniauth :mixi, OAUTH_CONFIG[:mixi]['key'], OAUTH_CONFIG[:mixi]['secret']

  # https://github.com/arunagw/omniauth-twitter
  # https://dev.twitter.com/docs/api/1.1
  #config.omniauth :twitter, OAUTH_CONFIG[:twitter]['key'], OAUTH_CONFIG[:twitter]['secret']
end