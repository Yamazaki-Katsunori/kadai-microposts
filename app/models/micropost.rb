class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 255 }
  
  #お気に入り投稿用のfavorites関係モデル用宣言(micropostモデルからfavoritesテーブルのuser_idを参照したいため)
  has_many :favorites
  has_many :favoriters, through: :favorites, source: :user
  
end
