# LinkedIn.configure do |config|
#   config.client_id     = ENV["78jiaqir16u8ah"]
#   config.client_secret = ENV["rlDe8Wm2s5RtmEuW"]

#   # This must exactly match the redirect URI you set on your application's
#   # settings page. If your redirect_uri is dynamic, pass it into
#   # `auth_code_url` instead.
#   config.redirect_uri  = "https://labs-373-jennyzhu84.c9users.io/login"
# end

# access_token = oauth.get_access_token(code)
# api = LinkedIn::API.new(access_token)
# me = api.profile
# my_name = api.profile(fields: ["first-name", "last-name"])
# my_job_titles = api.profile(fields: ["id", {"positions" => ["title"]}])

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :linkedin, "78jiaqir16u8ah", "rlDe8Wm2s5RtmEu",
#   scope: 'r_basicprofile' #'r_liteprofile' 'r_emailaddress'
#   #fields: ['id'] #, 'first-name', 'last-name', 'location', 'picture-url', 'public-profile-url']

#   OmniAuth.config.on_failure = Proc.new do |env|
#     SessionsController.action(:auth_failure).call(env)
#     #error_type = env['omniauth.error.type']
#     #new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{error_type}"
#     #[301, {'Location' => new_path, 'Content-Type' => 'text/html'}, []]
#   end
# end

Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_SECRET"],
#           scope: 'profile', image_aspect_ratio: 'square', image_size: 48, name: 'google',
#           access_type: "offline", skip_jwt: true

	provider :linkedin, "78qg5opgopeavo", "49lDCPZMNrTSkFo8",
           #scope: 'r_basicprofile'
           fields: ['id', 'first-name', 'last-name', 'email-address', 'location', 'picture-url', 'public-profile-url']

  OmniAuth.config.on_failure = Proc.new do |env|
    SessionsController.action(:auth_failure).call(env)
    #error_type = env['omniauth.error.type']
    #new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{error_type}"
    #[301, {'Location' => new_path, 'Content-Type' => 'text/html'}, []]
  end
end
