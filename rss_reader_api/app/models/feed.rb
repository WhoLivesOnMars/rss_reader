class Feed < ApplicationRecord
    has_many :feed_items, dependent: :destroy
    
    validates :title, :url, presence: true
    validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
    validates :url, uniqueness: true

    after_commit -> { FetchFeedsJob.perform_later }, on: :create
end
