class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "この拡張子は無効です" },
                      size:         { less_than: 5.megabytes,
                                      message: "サイズが大きいです" },
                      presence: true
end
