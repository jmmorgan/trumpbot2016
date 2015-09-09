class CreateSentTweets < ActiveRecord::Migration
  def change
    create_table :sent_tweets do |t|
      t.bigint :twitter_id
      t.bigint :in_reply_to_twitter_id
      t.string :text

      t.timestamps null: false
    end
  end
end
