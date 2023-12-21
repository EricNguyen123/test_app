# README


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### Start and note
npm install

* Note:
* javarscript/application.js 
delete import "jquery_ujs" and import "popper"

npm run build

* Note:
* javarscript/application.js 
add import "jquery_ujs" and import "popper"

* assets/builds/
change name application.js to _application.js

rails s 

######





### Login with Google, Facebook, Github, ...

* Gemfile add gems
gem 'dotenv-rails'
gem 'omniauth'
gem "omniauth-rails_csrf_protection", "~> 1.0"

gem 'omniauth-google-oauth2'
gem 'omniauth-github', '~> 2.0.0'
gem 'omniauth-facebook'

* config/initializers/omniauth.rb 

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    provider :facebook, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
end
OmniAuth.config.allowed_request_methods = %i[get]

* .env
(add tokens id)
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GITHUB_KEY=...
GITHUB_SECRET=...
CONSUMER_KEY=...
CONSUMER_SECRET=....

* routes.rb

get '/auth/github/callback', to: 'sessions#gitauth'
get 'auth/facebook/callback', to: 'sessions#facebookauth'
get '/auth/:provider/callback', to: 'sessions#omniauth'

* sessions_controller.rb

def gitauth
    user = User.find_or_create_by(provider: request.env['omniauth.auth'][:info][:nickname],uid: request.env['omniauth.auth'][:uid])
    user.name = request.env['omniauth.auth'][:info][:nickname]
    user.email = request.env['omniauth.auth'][:info][:nickname] + '@gmail.com'
    user.password = SecureRandom.urlsafe_base64
    if user.save
      user.send_activation_email
      log_in user
      redirect_to root_url
    else
      redirect_to login_path
    end
  end

  def omniauth
    user = User.find_or_create_by(uid: request.env['omniauth.auth'][:provider] , provider: request.env['omniauth.auth'][:uid]) do |user|
      user.name = request.env['omniauth.auth'][:info][:first_name]
      user.email = request.env['omniauth.auth'][:info][:email]
      user.password = SecureRandom.urlsafe_base64
    end
    if user.valid?
      user.send_activation_email
      log_in user
      redirect_to root_url
    else
      redirect_to login_path
    end
  end

  def facebookauth
    user = User.find_or_create_by(uid: request.env['omniauth.auth'][:provider] , provider: request.env['omniauth.auth'][:uid]) do |user|
      user.name = request.env['omniauth.auth'][:info][:name]
      user.email = request.env['omniauth.auth'][:info][:email]
      user.password = SecureRandom.urlsafe_base64
      
    end
    if user.valid?
      user.send_activation_email
      log_in user
      redirect_to root_url
    else
      redirect_to login_path
    end
  end

* add links button for login

<%= link_to image_tag("web_light_rd_SI@1x.png", height: "42"), '/auth/google_oauth2' %>
<%= link_to image_tag("GitHub_Logo.png", height: "42"), '/auth/github', data: { turbo: false }  %>
<%= link_to image_tag("facebook_login_icon.png", height: "42"), '/auth/facebook', data: { turbo: false } %>