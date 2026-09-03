class GrowFeedItemsUrlAndGuid < ActiveRecord::Migration[7.1]
  def up
    remove_index :feed_items, :url  if index_exists?(:feed_items, :url)
    remove_index :feed_items, :guid if index_exists?(:feed_items, :guid)

    change_column :feed_items, :url,  :string, limit: 2048, null: false
    change_column :feed_items, :guid, :string, limit: 1024, null: false

    add_index :feed_items, :url,  length: 191 unless index_exists?(:feed_items, :url)
    add_index :feed_items, :guid, unique: true, length: 191 unless index_exists?(:feed_items, :guid)
  end

  def down
    remove_index :feed_items, :url  if index_exists?(:feed_items, :url)
    remove_index :feed_items, :guid if index_exists?(:feed_items, :guid)

    change_column :feed_items, :url,  :string, limit: 255, null: false
    change_column :feed_items, :guid, :string, limit: 255, null: false

    add_index :feed_items, :url  unless index_exists?(:feed_items, :url)
    add_index :feed_items, :guid, unique: true unless index_exists?(:feed_items, :guid)
  end
end
