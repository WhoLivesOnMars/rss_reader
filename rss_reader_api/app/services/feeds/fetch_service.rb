require "open-uri"

module Feeds
  class FetchService
    BACKOFF_BASE = 5.minutes
    BACKOFF_MAX  = 12.hours

    def self.call(feed)
      if feed.backoff_until.present? && feed.backoff_until > Time.current
        Rails.logger.info "[FetchService] skip feed_id=#{feed.id} until #{feed.backoff_until}"
        return
      end

      xml = URI.open(feed.url, read_timeout: 15).read
      parsed = Feedjira.parse(xml)

      (parsed.entries || []).each do |e|
        guid = e.entry_id || e.url || e.link
        next if guid.blank?
        next if FeedItem.exists?(feed_id: feed.id, guid: guid)

        FeedItem.create!(
          feed_id: feed.id,
          guid: guid,
          title: e.title.presence || "Untitled",
          url: e.url || e.link,
          summary: (e.summary || e.content || "").to_s,
          published_at: e.published || Time.current,
          read: false
        )
      end

      feed.update!(last_fetched_at: Time.current, error_count: 0, last_error_at: nil, backoff_until: nil)
    rescue => ex
      Rails.logger.error "[FetchService] feed_id=#{feed.id} #{ex.class}: #{ex.message}"
      
      ec   = (feed.error_count || 0) + 1
      wait = [BACKOFF_BASE * (2 ** (ec - 1)), BACKOFF_MAX].min
      feed.update!(
        error_count:  ec,
        last_error_at: Time.current,
        backoff_until: Time.current + wait
      )
    end
  end
end
