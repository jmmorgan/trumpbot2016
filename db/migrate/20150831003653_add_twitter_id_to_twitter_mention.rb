class AddTwitterIdToTwitterMention < ActiveRecord::Migration
  def change
    add_column :twitter_mentions, :twitter_id, :int, limit: 8
  end
end
