class CreateFeeds < ActiveRecord::Migration[8.0]
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.datetime :last_fetched_at

      t.timestamps
    end
    add_index :feeds, :url
  end
end
