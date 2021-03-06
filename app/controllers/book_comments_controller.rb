class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    # redirect_to book_path(book)は非同期通信化のため削除
  end

  def destroy
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new
    BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    # redirect_to book_path(params[:book_id])は非同期通信化のため削除
  end

  # createとdestroyのredirect先のidの指定方法の違いが分からない。どちらもbook_idで同じじゃないのか。
  # createの方のbookは変数のbookであってbook_idの省略形ではないのかも。

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
