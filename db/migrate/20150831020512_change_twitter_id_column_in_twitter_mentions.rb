class ChangeTwitterIdColumnInTwitterMentions < ActiveRecord::Migration
  def change
    change_column :twitter_mentions, :twitter_id, :bigint
  end
end
