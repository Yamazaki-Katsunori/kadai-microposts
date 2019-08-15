class User < ApplicationRecord
  before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    
    #関係コード群（バリデーション）
    has_many :microposts
    
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    #お気に入り投稿用のfavorites関係モデル用宣言(userモデルからfavoritesテーブルのmicropost_idを参照したいため)
    has_many :favorites
    has_many :favoriteings, through: :favorites, source: :micropost
    
    
    #follow作成メソッド
    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end
    
    #follow解除メソッド
    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
    
    #followしているかの判定メソッド
    def following?(other_user)
      self.followings.include?(other_user)
    end
    
    #タイムライン用のマイクロポストを取得するメソッド
    def feed_microposts
      Micropost.where(user_id: self.following_ids + [self.id])
    end
    
    #課題のお気に入り追加・解除メソッド群#
    
    #favorites(お気に入り追加)作成メソッド
    def favorite_micropost(other_micropost)
      self.favorites.find_or_create_by(micropost_id: other_micropost.id)
    end
    
    #favorites(お気に入り解除[destory])メソッド
    def unfavorite_micropost(other_micropost)
      favorite = self.favorites.find_by(micropost_id: other_micropost.id)
      favorite.destroy if favorite
    end
    
    #favorite（お気に入り）しているかの判定メソッド
    def favoriteing?(other_micropost)
      self.favoriteings.include?(other_micropost)
    end
    
    
    
   
    
end
