class PublishersController < ApplicationController

  def index

  if params[:search]
      @publishers = Publisher.search(params[:search]).page(params[:page])
    else
      @publishers = Publisher.all.page(params[:page])
    end
    respond_to do|format|
      format.html
      format.xls{send_data @publishers.to_csv(col_sep: "\t") }
    end
    
  end

  def show
  @publisher = Publisher.find_by_id(params[:id])
  end 

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      flash[:info] = 'OK'
      redirect_to(publishers_url)
    else
      render 'new'
    end
    respond_to do|format|
      format.html
      format.xls{send_data @publishers.to_csv(col_sep: "\t") }
    end
  end

  def edit
    @publisher = Publisher.find_by_id( params[:id] )
  end

  def update
    @publisher = Publisher.find(params[:id])
    if @publisher.update_attributes(publisher_params) # returns true only on succesful update!
      # Handle a successful update.
      flash[:success] = "Publisher has been successfully updated!"
      redirect_to (@publisher)
    else
      render 'edit'
    end
  end

  def destroy
    Publisher.find_by_id( params[:id] ).destroy
    flash[:success] = 'Publisher successfully deleted!'
    redirect_to (publishers_url)
  end


  private

  def publisher_params
    params.require(:publisher).permit(:publisher_name,:address)
  end

  # Before filters

  # Confirms the correct user.

end