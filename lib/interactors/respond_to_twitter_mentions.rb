# Class should be initialized with a request parameter where request[:twitter_client]
# returns an instance of Twitter::REST::Client
class Interactors::RespondToTwitterMentions < Interactor
  REPLY_LIMIT = 5 # Arbitrary starting point

  def call
    client = @request[:twitter_client]

    mentions = TwitterMention.where('replied IS NOT TRUE').order(twitter_id: :desc).limit(REPLY_LIMIT).each do |mention|
      chat_response = Interactors::QueryBot.new(input: strip_mentions(mention.text)).call()
      response_texts = build_response_texts(chat_response, mention.screen_name)
      mention.update_attributes!(replied: true)
      response_texts.each do |response_text|
        client.update(response_text, in_reply_to_status_id: mention.twitter_id)
      end
    end
  end

  private 

  def build_response_texts(chat_response, screen_name)
    full_text = "#{chat_response.outputs.join(' ')}"
    response = Interactors::FormatTweets.new({text: full_text, screen_names: [screen_name]}).call()
    response[:tweets]
  end

  def strip_mentions(text)
    text.gsub(/(^|\W)@\w+/, ' ')
  end
end
