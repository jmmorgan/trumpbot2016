# Class should be initialized with a request parameter where request[:twitter_client]
# returns an instance of Twitter::REST::Client
class Interactors::RespondToTwitterMentions < Interactor
  REPLY_LIMIT = 5 # Arbitrary starting point

  def call
    client = @request[:twitter_client]

    mentions = TwitterMention.where('replied IS NOT TRUE').order(twitter_id: :desc).limit(REPLY_LIMIT).each do |mention|
      chat_response = Interactors::QueryBot.new(input: strip_mentions(mention.text)).call()
      full_text = "#{chat_response.outputs.join(' ')}"
      mention.update_attributes!(replied: true)
      Interactors::SendTweets.new({twitter_client: client, text: full_text, 
        screen_names: [mention.screen_name], in_reply_to_status_id: mention.twitter_id}).call()
    end
  end

  private 

  def strip_mentions(text)
    text.gsub(/(^|\W)@\w+/, ' ')
  end
end
