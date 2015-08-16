namespace :trumpbot do

  task :generate_conversation, [:input_file, :output_file] => [:environment] do |t, args|

    input_file = args[:input_file] || "#{Rails.root}/spec/support/conversation_input.txt"
    output_file = args[:output_file] || "#{Rails.root}/spec/support/conversation_output.txt"

    chat_session = ChatSession.create!
    chat = chat_session.chat

    File.open(output_file, 'w') do |f|
      File.readlines(input_file).each do |line|
        line = line.strip
        
        human_line = "Human: #{line.strip}"
        f.puts human_line
        puts human_line
        
        chat_response = chat.respond(line.strip)

        bot_line = "TrumpBot: #{chat_response.outputs.last}"
        f.puts bot_line
        puts bot_line

        matched_pattern_line = "MATCHED PATTERN: #{chat_response.matched_patterns.last}"
        f.puts matched_pattern_line
        puts matched_pattern_line

        f.puts
        puts
      end
    end

  end
end
