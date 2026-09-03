class AddFetchBackoffToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :error_count, :integer
    add_column :feeds, :last_error_at, :datetime
    add_column :feeds, :backoff_until, :datetime
  end
end
