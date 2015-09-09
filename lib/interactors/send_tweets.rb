# Class should be initialized with a request parameter where:
# - request[:twitter_client] an instance of Twitter::REST::Client
# - request[:text] contains the text to be tweeted. Mayb ebe broken up into multiple tweets if the character limit is exceeded.
# - request[:screen_names] contains an optional array of Twitter screen names to include in the message(s). Optional.
# - request[:hash_tags] contains an optional array of hash tags to be appended to the last message. Optional.
# - request[:in_reply_to_status_id] Optional.
#
# #call() will return a response where response[:tweets] will contain the array of type Twitter::Tweet
class Interactors::SendTweets < Interactor

  def call()
    result = []
    messages = Interactors::FormatTweets.new(@request).call()[:tweets]
    client = @request[:twitter_client]
    # Not too worried about error handling yet
    messages.each do |message|
      tweet = client.update(message, in_reply_to_status_id: request[:in_reply_to_status_id])
      result << tweet
      SentTweet.create!(twitter_id: tweet.id, in_reply_to_twitter_id: tweet.in_reply_to_status_id,
        text: tweet.text)
    end

    result
  end
end


