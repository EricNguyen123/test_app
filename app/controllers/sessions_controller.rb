class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      # Create an error message.
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

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
end
