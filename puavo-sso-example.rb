require 'json'
require 'jwt'
require 'sinatra'
require 'sinatra/config_file'

config_file './config.yml'

# Handle routes that are not found
not_found do
  'Not found'
end

get '/' do
  jwt = params[:jwt]
  if jwt
    begin
      decoded_token = JWT.decode(jwt, settings.sharedsecret, true, { verify_iat: true, algorithm: 'HS256' })
      @iat_human = Time.at(decoded_token[0]['iat'])
      @data = JSON.pretty_generate(decoded_token)
      erb :index
    rescue => error
      @error_message = error.to_s
      erb :error
    end
  else
    redirect "#{settings.redirect_to_url}#{settings.return_to_url}"
  end
end

get '/logout' do
  erb :logout
end
