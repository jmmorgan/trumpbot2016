namespace :trumpbot do

  task :generate_conversation, [:input_file, :output_file] => [:environment] do |t, args|

    input_file = args[:input_file] || "#{Rails.root}/spec/support/conversation_input.txt"
    output_file = args[:output_file] || "#{Rails.root}/spec/support/conversation_output.txt"

    chat_session = ChatSession.create!

    num_requests = 0
    num_requests_no_wildcards = 0
    matched_pattern_counts = Hash.new(0)

    File.open(output_file, 'w') do |f|
      File.readlines(input_file).each do |line|
        line = line.strip
        num_requests += 1
        
        human_line = "Human: #{line.strip}"
        f.puts human_line
        puts human_line
        
        chat_response = chat_session.respond(line.strip)

        bot_line = "TrumpBot: #{chat_response.outputs.join(' ')}"
        f.puts bot_line
        puts bot_line

        chat_response.category_trees.each do |category_tree|
          # Law of Demeter smell!
          matched_pattern = category_tree.root.category.pattern.to_s
          matched_pattern_counts[matched_pattern] += 1
          num_requests_no_wildcards += 1 if matched_pattern !~ /[\_#\^\*<]/
          matched_pattern_line = "MATCHED PATTERN: #{matched_pattern}"
          f.puts matched_pattern_line
          puts matched_pattern_line
          category_tree_lines = "CATEGORY TREE:\n#{category_tree.to_s}"
          f.puts category_tree_lines
          puts category_tree_lines
        end

        f.puts
        puts
      end
    end

    puts "Stats:"
    puts "Requests: #{num_requests}"
    puts "Requests with no wilcard matches: #{num_requests_no_wildcards}"
    puts "Matched paterns:"
    matched_pattern_counts.sort{|a, b| b[1] <=> a[1]}.each do |array|
      puts "[#{array[0]}]: #{array[1]}"
    end

  end

  task :respond_to_twitter_mentions => [:environment] do |t, args|
    client = twitter_rest_client

    Interactors::CollectNewTwitterMentions.new(twitter_client: client).call
    Interactors::RespondToTwitterMentions.new(twitter_client: client).call
  end

  task :tweet_campaign_message => [:environment] do |t, args|
    # For now we have this task scheduled in Heroku to
    # run every hour, but let's only tweet once every three hours
    next unless (Time.now.hour % 3) == 0
    client = twitter_rest_client
    max_tries = 20
    # TODO: Encapsulate this logic in interactor(s)?
    recent_tweets = client.user_timeline('realtrumpbot').map(&:text)
    max_tries.times do 
      message = ChatSession.new.respond(['CAMPAIGN', 'RIVALS', 
        'RANDOM PICKUP LINE'].sample).outputs.first
      if (!message_already_tweeted?(message))
        Interactors::SendTweets.new({twitter_client: client, text: message}).call()
        break
      end
    end
  end
end

def twitter_rest_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TRUMPBOT_TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TRUMPBOT_TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TRUMPBOT_TWITTER_ACCESS_TOKEN']  
      config.access_token_secret = ENV['TRUMPBOT_TWITTER_ACCESS_SECRET']
    end
end

def message_already_tweeted?(message)
    # VERY QUICK AND DIRTY
    # For now we'll just take the first 30 chars of the message and search against sent tweets
    SentTweet.where('text like ?', "%#{message.slice(0,30).strip}%").present?
end
