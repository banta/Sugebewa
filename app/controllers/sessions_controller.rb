class SessionsController < ApplicationController
  def forgot_password
    check
    if request.post?
      @user = User.find_by_email(params[:user][:email])
      if @user and @user.send_new_password
        flash[:notice]  = t(:pass_sent)
        redirect_to(:action => 'login')
      else
        flash[:alert]  = t(:pass_not_sent)
      end
    end
  end

  def login
    check
    if request.post?
      user = User.authenticate(params[:email], params[:password])

      unless user.nil?
        if params[:remember_me] == 'true'
          user.refresh_remember_token
          cookies[:auth_token] = { :value => user.remember_token, :expires => 2.days.from_now }
        end

        session[:user_id] = user.id
        redirect_to :controller => 'microposts', :action => 'index'
      else
        flash[:alert] = t(:credentials_incorrect)
        redirect_to(:controller => 'sessions', :action => 'login')
      end
    end
  end

  def resend_mail
    check
    if request.post?
      @user = User.find_by_email(params[:user][:email])
      if @user and @user.send_new_password
        flash[:notice]  = t(:mail_sent)
        redirect_to(:action => 'login')
      else
        flash[:alert]  = t(:mail_not_sent)
      end
    end
  end

  def logout
    @user = User.find(User.find(session[:user_id]).id)
    @user.remember_token = "NULL"
    cookies.delete :auth_token
    @user.update_attributes(params[:user])
    session[:user_id] = nil
    flash[:notice] = t(:logged_out)
    redirect_to(:action => "login")
  end

end
