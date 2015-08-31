# Class should be initialized with a request parameter where request[:twitter_client]
# returns an instance of Twitter::REST::Client
class Interactors::CollectNewTwitterMentions < Interactor

  def call
    client = @request[:twitter_client]
    max_twitter_id = TwitterMention.maximum(:twitter_id) || 0
    result = {twitter_mentions: []}
    client.mentions_timeline(since: max_twitter_id).each do |tweet|
      result[:twitter_mentions] << TwitterMention.where(twitter_id: tweet.id).first_or_create do |twitter_mention|
        twitter_mention.screen_name = tweet.user.screen_name
        twitter_mention.text = tweet.text
        replied = false
      end
    end

    result
  end
end
