class CategoriesController < ApplicationController
   def index
 # @authors = Author.paginate( page: params[:page] )
  if params[:search]
      @categories = Category.search(params[:search]).page(params[:page])
    else
      @categories = Category.all.page(params[:page])
    end
    respond_to do|format|
      format.html
      format.xls{send_data @categories.to_csv(col_sep: "\t") }
    end
  end

  def show
  @category = Category.find_by_id(params[:id])
  end 

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
      if @category.save
      flash[:info] = 'OK'
      redirect_to(categories_url)
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find_by_id( params[:id] )
  end

  def update
    @category = Category.find_by_id(params[:id])
    if @category.update_attributes(category_params) # returns true only on succesful update!
      # Handle a successful update.
      flash[:success] = "Category has been successfully updated!"
      redirect_to (@category)
    else
      render 'edit'
    end
  end

  def destroy
    Category.find_by_id( params[:id] ).destroy
    flash[:success] = 'category successfully deleted!'
    redirect_to (categories_url)
  end


  private

  def category_params
    params.require(:category).permit(:category_name)
  end

  # Before filters

  # Confirms the correct user.

end