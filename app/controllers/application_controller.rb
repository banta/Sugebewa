class ApplicationController < ActionController::Base
  before_filter :require_login, :except => [:new, :create, :login, :forgot_password, :resend_mail]


  helper :all # include all helpers, all the time
  protect_from_forgery

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def require_login
    if User.find_by_id(session[:user_id]).nil?
      user = User.find_by_remember_token(cookies[:auth_token]) unless cookies[:auth_token].blank?

      if user.nil?
        reset_session
        session[:user_id] = nil
        session[:return_to] = request.fullpath
        redirect_to(:controller => :sessions, :action => :login)
      else
        user.refresh_remember_token
        session[:user_id] = user.id
        cookies[:auth_token] = user.remember_token
      end
    end
  end

  private

  def allow_user
    unless User.find_by_id(session[:user_id])
      flash[:alert] = t(:please_login)
      redirect_to :controller => :users, :action => :login
    end
  end

  def check
    user = User.find_by_remember_token(cookies[:auth_token]) unless cookies[:auth_token].blank?

    if session[:user_id] or user
      redirect_to :action => :index
    end
  end
end