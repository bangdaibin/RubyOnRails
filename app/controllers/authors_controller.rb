class AuthorsController < ApplicationController
  before_action :admin_user, only: [:destroy, :edit]
  def index

  if params[:search]
      @authors = Author.search(params[:search]).page(params[:page])
    else
      @authors = Author.all.page(params[:page])
    end
    respond_to do|format|
      format.html
      format.xls{send_data @authors.to_csv(col_sep: "\t") }
    end
    
  end

  def show
  @author = Author.find_by_id(params[:id])
  end 

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      flash[:info] = 'OK'
      redirect_to(authors_url)

    else
      render 'new'
    end
  end

  def edit
    @author = Author.find_by_id( params[:id] )
  end

  def update
    @author = Author.find_by_id(params[:id])
    if @author.update_attributes(author_params) # returns true only on succesful update!
      # Handle a successful update.
      flash[:success] = "Profile has been successfully updated!"
      redirect_to (@author)
    else
      render 'edit'
    end
  end

  def destroy
    Author.find_by_id( params[:id] ).destroy
    flash[:success] = 'author successfully deleted!'
    redirect_to (authors_url)
  end


  private

  def author_params
    params.require(:author).permit(:author_name,:birth)
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