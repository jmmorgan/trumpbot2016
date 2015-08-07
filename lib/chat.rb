class Chat
  attr_accessor :chat_session_id, :requests, :responses, :predicates, :that

  def initialize(chat_session_id)
    @chat_session_id = chat_session_id
    @requests = []
    @responses = []
    @predicates = {}
    @that = '*'
  end

  def respond(input)
    @requests << input
    sentences = normalize(input)
    path_matcher = PathMatcher.new
    normalized_responses = []
    predicates['_chat_session_id'] = @chat_session_id

    sentences.each do |sentence|
      path_result = path_matcher.get_matching_path(GRAPHMASTER, sentence, @chat_session_id, @that, '*')
      normalized_responses << path_result.apply_template(predicates)
    end

    @that = normalize(normalized_responses.last).last || '*' 
    response = denormalize(normalized_responses).join(' ') 

    @responses << response
    train()
    response
  rescue => e
    # For now we'll just return a default response and move forward
    (@responses << "I'm having trouble understanding you").last
  end

  def clear
    @requests.clear
    @responses.clear
    @predicates.clear
  end

  def transcript
    result = ''
    @requests.each_index do |i|
      result << "You: #{@requests[i]}" << "\n"
      if (response =  responses[i])
        result << "TrumBot: #{response}" << "\n"
      end
    end

    result
  end

  def to_json
    {
      'chat_session_id' => @chat_session_id,
      'requests' => @requests,
      'responses' => @responses,
      'predicates' => @predicates,
      'that' => @that
      }.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    result = self.allocate
    result.chat_session_id = hash["chat_session_id"]
    result.requests = hash['requests'] || []
    result.responses = hash['responses'] || []
    result.predicates = hash['predicates'] || {}
    result.that = hash['that'] || '*'
    result
  end

  private

  # TODO: This current implementation is somewhat brittle in that the order that entries in the
  # map file are applied affects the 'normalized' result. Should revisit if this project develops legs.
  def normalize(input)
    sentences = input.split(/[#{Regexp.quote(PROPERTIES_MAP_FILE['sentence-splitters'])}](\s+|$)/).reject(&:blank?)
    sentences = sentences.map{|sentence| " #{sentence} "} # Pad with spaces for normal substitutions
    sentences.each do |sentence|
      NORMAL_SUBSTITUTION_MAP_FILE.each_pair do |key, value|
        sentence.gsub!(/(#{Regexp.quote(key)})/i, value)
      end
    end
    sentences.map(&:strip!)

    sentences.each_index do |i|
      # Normalize interword spaces and convert to caps
      original_tokens = sentences[i].split
      upcase_tokens = original_tokens.map(&:upcase)
      sentences[i] = upcase_tokens.join(' ')
    end
    
    sentences
  end

  # TODO: refactor.
  def denormalize(normalized_responses)
    result = normalized_responses

    # Clean out leading spaces before punctuation (may need to to tweak this as we go along)
    result = result.collect{|sentence| sentence.gsub(/\s+([\.\?!,\:;])/, '\1').strip}

    # TODO: Maybe logic like below should be encapsulated in a Bot Brain (Which also encapsulate the Graphmaster)
    # Convert ALL CAPS words to title case
    used_words = requests.inject(Set.new){|memo, request| request.scan(/\s+(\b\w+\b)/).flatten.each {|word| memo.add(word)}; memo}
    result.each do |sentence|
      sentence.scan(/\b[A-Z0-9]+\b/).each do |word|
        # For now, if the word in its title case form has been used in the chat (excluding start of a sentence)
        # then use the title case form.  Otherwise, use the downcase.
        # Super hacky.  See 'Bot Brain' comment above.  Getting capitalization right in almost all cases might
        # prove very tricky.
        titlecase = word.titlecase
        sentence.gsub!(/\b#{word}\b/, used_words.include?(titlecase) || titlecase.length < 2 ? titlecase : word.downcase)
      end
      
      # Capitalize first character in sentence ()
      sentence[0] = sentence[0].upcase
    end

    result
  end

  # Apply learned categories to graphmaster
  def train
    learned_categories = predicates["_learned_categories"] 

    if (learned_categories)
      parser = Parsers::CategoryXmlParser.new
      learned_categories.each do |xml|
        GRAPHMASTER.add_category(parser.parse(Nokogiri::XML(xml).root), @chat_session_id)
      end
    end
  end
end
