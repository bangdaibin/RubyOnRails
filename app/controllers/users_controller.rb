class UsersController < ApplicationController
  # Define what are allowed for which user

  # Refactored code above into:
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]

  before_action :admin_user, only: [:destroy, :edit]

   def index
 # @authors = Author.paginate( page: params[:page] )
  if params[:search]
      @users = User.search(params[:search]).page(params[:page])
    else
      @users = User.all.page(params[:page])
    end
  end

  def show
  @user = User.find(params[:id])
  end 

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to(root_url)

    else
      render 'new'
    end
  end

  def edit
    @user = User.find( params[:id] )
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) # returns true only on succesful update!
      # Handle a successful update.
      flash[:success] = "Profile has been successfully updated!"
      redirect_to (@user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find( params[:id] ).destroy
    flash[:success] = 'User successfully deleted!'
    redirect_to (users_url)
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end