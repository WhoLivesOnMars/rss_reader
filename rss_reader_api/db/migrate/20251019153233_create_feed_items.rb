class CreateFeedItems < ActiveRecord::Migration[8.0]
  def change
    create_table :feed_items do |t|
      t.references :feed, null: false, foreign_key: true
      t.string :title
      t.string :url
      t.text :summary
      t.datetime :published_at
      t.boolean :read, default: false, null: false
      t.string :guid

      t.timestamps
    end
    add_index :feed_items, :url
    add_index :feed_items, :guid
  end
end
