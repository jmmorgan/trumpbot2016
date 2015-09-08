# Class should be initialized with a request parameter where:
# - request[:text] contains the text to be tweeted
# - request[:screen_names] contains an optional array of Twitter screen names to include
# - request[:hash_tags] contains an optional array of hash tags to be included in the message
#
# #call() will return a response where response[:tweets] will contain the array of messages
class Interactors::FormatTweets < Interactor

  def call
    response = {tweets: []}
    full_text = request[:text].to_s + request[:hash_tags].to_a.join(' ')
    full_text = Interactors::TransformNamesToTwitterHandles.new(full_text).call()
    screen_names = request[:screen_names].to_a.collect{|n| "@#{n}"}.join(' ')
    if (screen_names.length + full_text.length + 2 > 140)
      # We'll assume for now that pagination does not exceed 9 tweets
      # We're also just chopping the messages up according to space without accounting 
      # for logical breaks like spaces, sentence endings, etc.
      # We can get more sophisticated if this feature ever gets serious usage.
      pagination_space = 3
      spaces = 2
      screen_names_space = screen_names.length
      message_space = 140 - pagination_space - spaces - screen_names_space
      page_count = full_text.length / message_space + (full_text.length % message_space == 0 ? 0 : 1)
      page_count.times do |i|
        response[:tweets] << "#{screen_names} #{full_text.slice(message_space * (i), message_space)} #{i+1}/#{page_count}"
      end
    else
      response[:tweets] = ["#{screen_names} #{full_text}"]
    end

    response
  end
end
