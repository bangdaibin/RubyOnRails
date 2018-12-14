class BooksController < ApplicationController
  def index
   if params[:search]
      @books = Book.search(params[:search]).page(params[:page])
  else
   if params[:category].blank?
			@books = Book.paginate( page: params[:page] )
		else
			@category_id = Category.find_by_category_name(params[:category]).id
			@books = Book.where(:category_id => @category_id).paginate( page: params[:page] )
		end
  end
   respond_to do|format|
      format.html
      format.xls{send_data @books.to_csv(col_sep: "\t") }
    end
  end

  def show
  @book = Book.find_by_id(params[:id])
  end 

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
       redirect_to books_path, notice: "Book saved"
    else
      render 'new'
    end
  end


  def edit
    @book = Book.find( params[:id] )
  end

  def update
    @book = Book.find_by_id(params[:id])
    if @book.update_attributes(book_params) # returns true only on succesful update!
      # Handle a successful update.
      flash[:success] = "Book has been successfully updated!"
      redirect_to (@book)
    else
      render 'edit'
    end
  end

  def destroy
    Book.find_by_id( params[:id] ).destroy
    flash[:success] = 'book successfully deleted!'
    redirect_to (books_url)
  end

  	def show
		@book = Book.find( params[:id] )
		if @book.reviews.blank?
			@average_review = 0
		else
			@average_review = @book.reviews.average(:rating).round(2)
		end
	end

  private

  def book_params
    params.require(:book).permit(:title,:description,:book_img, :author_attributes=> [:id,:author_name], :category_attributes=>[:id,:category_name], :publisher_attributes=>[:id, :publisher_name])
  end
  def find_book
			@book = Book.find(params[:id])
  end
  

  # Before filters

  # Confirms the correct user.
end
