class FetchFeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Feed.find_each { |feed| Feeds::FetchService.call(feed) }
  end
end
