class BooksController < ApplicationController	
	before_action :find_user, only: [:show,:edit,:update,:destroy]
	before_action :authenticate_user!
	
	
	def index
   	     
   	   if params[:search]
   	      @books = Book.all.includes(:user).where("lower(title) LIKE ? or lower(text) LIKE ? ", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%")  	   
   	   else
   		  @books = Book.all.includes(:user) 
   		end
   		respond_to do |format|
          format.html  # index.html.erb
          format.js
        end
    end
	
	def show
	    
  	end
	
	def new
		@book = Book.new
	end
  	
  	def edit
	end
  	
  	def create
  		@book = Book.new(book_params)
  		@book.attachment = params[:book][:attachment]
  		@book.user_id = current_user.id
   		if @book.save
   			#BookMailer.registration_confirmation(current_user).deliver
	    	redirect_to @book
	   	else
	    	render 'new'
	   	end
  	end
  	
  	def update
	    if @book.update(book_params)
	      redirect_to @book
	    else
	      render 'edit'
	    end
  	end
 
	def destroy
		@book.destroy
		redirect_to books_path	
	end

	def find_user
		@book= Book.find(params[:id])
	end
	private
	def book_params
		params.require(:book).permit(:title, :text, :attachment)
	end

end
