class MicropostsController < ApplicationController
  # GET /microposts
  # GET /microposts.xml
  def index
    @user = User.find(User.find(session[:user_id]).id)
    @microposts = Micropost.from_users_followed_by(@user)  #find(:all, :order => 'updated_at desc')#, :conditions => ["user_id = '#{User.find(session[:user_id]).id}' and "]
    @micropost = Micropost.new
    @user = User.find(User.find(session[:user_id]).id)
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @microposts }
    end
  end

  # POST /microposts
  # POST /microposts.xml
  def create
    @micropost = Micropost.new(params[:micropost])
    @micropost.user_id = "#{User.find(User.find(session[:user_id]).id).id}"

    respond_to do |format|
      if @micropost.save
        format.html { redirect_to(microposts_path, :notice => t(:micropost_successfully_created)) }
        format.xml  { render :xml => microposts_path, :status => :created, :location => @micropost }
      else
        format.html { redirect_to(microposts_path, :alert => t(:micropost_not_created)) }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.xml
  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy

    respond_to do |format|
      format.html { redirect_to(microposts_path, :notice => "Successfully deleted") }
      format.xml  { head :ok }
    end
  end

  def user_microposts
    @user = User.find(params[:id])
    @microposts = Micropost.find_all_by_user_id(@user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @microposts }
    end
  end
end