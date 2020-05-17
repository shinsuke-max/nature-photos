class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "この拡張子は無効です" },
                      size:         { less_than: 5.megabytes,
                                      message: "サイズが大きいです" },
                      presence: true

  def liked_by(user)
    Like.find_by(user_id: user.id, post_id: id)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
