class SearchsController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    @records = search_for(@model, @content, @method)
  end

  # 解答だと以下はuserとbookのモデルに記載をしている。
  # userテーブルなのかbookテーブルなのかのif文は以下ではなくsearchメソッドの@recordのインスタンス変数のところでしている
  # 個人的にはsearchのコントローラは記述量も少ないしここにまとめたほうが良いような気はするけれど意味はあるのだろうか

  private
  def search_for(model, content, method)
    if model == 'user'
      if method == 'perfect'
        User.where(name: content)
      elsif method == 'partial'
        User.where('name LIKE ?', '%'+content+'%')
        # name LIKE = nameカラムを検索という意味
        # ? = これは引数の'%'+content+'%'を受け取る場所
        # 最終的にはname LIKE '%'+content+'%'という風になる
        # 参考：https://techacademy.jp/magazine/22330
      elsif method == 'forward'
        User.where('name LIKE ?', content+'%')
      elsif method == 'backward'
        User.where('name LIKE ?', '%'+content )
      else
        User.all
      end
    elsif model == 'book'
    # ここはelseでもいける
      if method == 'perfect'
        Book.where(title: content).or(Book.where(body: content))
      elsif method == 'partial'
        Book.where('title LIKE ?', '%'+content+'%').or(Book.where('body LIKE ?', '%'+content+'%'))
      elsif method == 'forward'
        Book.where('title LIKE ?', content+'%').or(Book.where('body LIKE ?', content+'%'))
      elsif method == 'backward'
        Book.where('title LIKE ?', '%'+content).or(Book.where('bodyLIKE ?', '%'+content))
      else
        Book.all
      end
    end
  end
end
