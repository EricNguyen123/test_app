# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include SessionsHelper

  def new
  end

  def create  
    user = User.find_by(email: params[:session][:email].downcase) 
    
    if user && user.valid_password_digest?(user, params[:session][:password])
      
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user) 
        redirect_to user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link." 
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
  
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end
end
