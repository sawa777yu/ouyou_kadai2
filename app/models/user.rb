class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # has_many :book_id, through: :favorites, source: :book
  # いいねのランキング機能実装について参考にしたサイトに上記記述もあったのだが、bookからfavoritesに関するuserモデルのuser_idを参照したいだけなので
  # この記述は不要だと思う。試しに外したらいけた。
  has_many :follower_of_relationships, class_name: "Relationship", foreign_key:"follower_id", dependent: :destroy
  # :follower_of_relationships <=  多分この文字はわかりやすければ何でも良い。これを使って後述の値を呼び出せる？
  # class_name: "Relationships" <= has_manyとかの後ろには本来はテーブル名とかが入ってくるのだと思うが中間リレーションを使った時は別の名前を当てる（？）ので
  # ここでRelationshipのテーブルを見てくださいねと定義する
  # foreign_key:"follower_id" <= class_nameで指定したテーブルのfollower_idというカラムを参照してくださいねという意味
  has_many :followings, through: :follower_of_relationships, source: :followed
  has_many :followed_of_relationships, class_name: "Relationship", foreign_key:"followed_id", dependent: :destroy
  has_many :followers, through: :followed_of_relationships, source: :follower

# 下記はインスタンスメソッドという
# コントローラで呼び出すことのできる、モデルに書くメソッドのこと
  def follow(user_id)
    follower_of_relationships.create(followed_id: user_id)
    # 上記のhas_many :follower_of_relationshipsを参照している
  end

  def unfollow(user_id)
    follower_of_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}


end
