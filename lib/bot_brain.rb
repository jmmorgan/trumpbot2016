# TODO: There is a lot of internal knowledge of predicates shared between BotBrain, Chat and the various template 
# implementations. This should be cleaned up, maybe with a Predicates class or some other way. 

class BotBrain

  def respond(input, previous_requests, predicates)
    result = {}
    result[:inputs] =  input.split(/(?<=[#{Regexp.quote(PROPERTIES_MAP_FILE['sentence-splitters'])}])(\s+|$)/).reject(&:blank?)
    sentences = normalize(input)
    path_matcher = PathMatcher.new
    normalized_responses = []
    result[:matched_patterns] = []
    sentences.each do |sentence|
      path_result = path_matcher.get_matching_path(GRAPHMASTER, sentence, predicates['_chat_session_id'], 
        predicates['that'] || '*', '*')
      result[:matched_patterns] << path_result.pattern
      normalized_responses << path_result.apply_template(predicates)
    end

    predicates['that'] = normalize(normalized_responses.last.to_s).last || '*' 
    result[:responses] =  denormalize(normalized_responses, previous_requests)
    train(predicates)
    result
  end

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
  def denormalize(normalized_responses, previous_requests)
    result = normalized_responses

    # Clean out leading spaces before punctuation (may need to to tweak this as we go along)
    result = result.collect{|sentence| sentence.gsub(/\s+([\.\?!,\:;])/, '\1').strip}

    # TODO: Maybe logic like below should be encapsulated in a Bot Brain (Which also encapsulate the Graphmaster)
    # Convert ALL CAPS words to title case
    used_words = previous_requests.to_a.inject(Set.new){|memo, request| request.scan(/\s+(\b\w+\b)/).flatten.each {|word| memo.add(word)}; memo}
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
  def train(predicates)
    learned_categories = predicates["_learned_categories"] 
    chat_session_id = predicates["_chat_session_id"]

    if (learned_categories)
      parser = Parsers::CategoryXmlParser.new
      learned_categories.each do |xml|
        GRAPHMASTER.add_category(parser.parse(Nokogiri::XML(xml).root), chat_session_id)
      end
    end
  end
  
end
