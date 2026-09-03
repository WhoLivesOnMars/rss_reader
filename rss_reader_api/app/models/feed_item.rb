class FeedItem < ApplicationRecord
  belongs_to :feed

  validates :title, :url, presence: true
  validates :guid, uniqueness: true, allow_nil: true, allow_blank: true
  scope :recent, -> { order(published_at: :desc, created_at: :desc) }
end
