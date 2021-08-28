class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    # @books = Book.where(user_id: @user.id)
    @books = @user.books
    # binding.pry
    # @books = @user.booksだとcurrentuserの一覧が表示される
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

# users/indexからの投稿のためにbookscontrollerより下記をコピペ
# createのアクションがユーザーになかったのでonlyに追加
# book_paramsの定義がなかったのでuserscontrollerに追加
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # 上記の記述がなくても更新ができていた。@userはどこで定義
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end


  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
