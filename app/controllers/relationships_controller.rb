class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:id])
    @relationship = Relationship.new(params[:relationship])

    @relationship.follower_id = User.find(User.find(session[:user_id]).id).id
    @relationship.followed_id = @user.id

    respond_to do |format|
      if @relationship.save
        format.html {redirect_to :controller => 'users' ,:action => 'show_user', :id => @user.id}
        flash[:notice] = 'User successfully followed'
      else
        format.html {redirect_to :controller => 'users' ,:action => 'show_user'}
        flash[:alert] = 'Error! Try again.'
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @relationship = Relationship.find_by_follower_id(User.find(session[:user_id]).id, :conditions => ["followed_id = '#{@user.id}'"])

    respond_to do |format|
      if @relationship.destroy
        format.html {redirect_to :controller => 'users' ,:action => 'show_user', :id => @user.id}
        flash[:notice] = 'User successfully unfollowed'
      else
        format.html {redirect_to :controller => 'users' ,:action => 'show_user', :id => @user.id}
        flash[:alert] = 'Error! Try again.'
      end
    end
  end

  def following

  end

  def followers

  end
end
