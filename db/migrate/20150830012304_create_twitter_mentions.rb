class CreateTwitterMentions < ActiveRecord::Migration
  def change
    create_table :twitter_mentions do |t|
      t.string :screen_name
      t.string :text
      t.boolean :replied

      t.timestamps null: false
    end
  end
end
