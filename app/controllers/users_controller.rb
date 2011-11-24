class UsersController < ApplicationController
  #downloads_files_for :user, :avatar
  # GET /users/new
  def show_user
    @user = User.find(params[:id])
    @microposts = Micropost.find(:all, :conditions => ["user_id = '#{@user.id}'"], :order => 'updated_at desc')
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  def other_users
    @users = User.find(:all, :conditions => ["id != '#{User.find(session[:user_id]).id}'"], :order => 'updated_at')

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @users }
    end
  end

  def new
    check
    @user = User.new
  end

  def show_info
    @user = User.find(User.find(session[:user_id]).id)
    @groups = Group.find(:all, :conditions => ["user_id = '#{User.find(session[:user_id]).id}'"], :order => 'updated_at')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end


  # GET /users/1/edit
  def edit
    @user = User.find(User.find(session[:user_id]).id)
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save and @user.send_new_password #send user a password
        format.html { redirect_to :action => 'index' }
        flash[:notice] = t(:user_registered)
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(User.find(session[:user_id]).id)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :action => 'show_info' }
        flash[:notice] = t(:user_updated)
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(User.find(session[:user_id]).id)
    @user.destroy

    respond_to do |format|
      session[:user_id] = nil
      format.html { redirect_to :controller => 'sessions', :action => 'login' }
      flash[:notice] = t(:user_deleted)
      format.json { head :ok }
    end
  end
end