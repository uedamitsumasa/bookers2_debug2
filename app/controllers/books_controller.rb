class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:update,:edit]

  def show
    @book = Book.find(params[:id])
    current_user.read_counts.create(book_id: @book.id)
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    @books = Book.includes(:favorited_users)
             .sort_by { |book| -book.favorited_users.size }
    @user = current_user
  end


  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      @user = current_user
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

  def ensure_correct_user
    @user = Book.find(params[:id]).user
    unless @user == current_user
      redirect_to books_path
    end
  end

end
