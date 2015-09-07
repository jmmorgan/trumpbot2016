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
    result = []
    full_text = "#{chat_response.outputs.join(' ')}"
    if (screen_name.length + full_text.length + 2 > 140)
      # We'll assume for now that pagination does not exceed 9 tweets
      # We're also just chopping the messages up according to space without accounting 
      # for logical breaks like spaces, sentence endings, etc.
      # We can get more sophisticated if this feature ever gets serious usage.
      pagination_space = 3
      spaces = 2
      screen_name_space = 1 + screen_name.length
      message_space = 140 - pagination_space - spaces - screen_name_space
      page_count = full_text.length / message_space + (full_text.length % message_space == 0 ? 0 : 1)
      page_count.times do |i|
        result << "@#{screen_name} #{full_text.slice(message_space * (i), message_space)} #{i+1}/#{page_count}"
      end
    else
      result = ["@#{screen_name} #{full_text}"]
    end

    result
  end

  def strip_mentions(text)
    text.gsub(/(^|\W)@\w+/, ' ')
  end
end
