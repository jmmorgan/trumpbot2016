class Bot

  def respond(input)
    sentences = normalize(input)

    sentences.each do |sentence|
      catgories = find_matching_categories(sentence)
      puts "CATGEORIES >> #{catgories}"
    end

    "You're normalized text is: #{sentences.join('|')}"
  end

  private

  def normalize(input)
    sentences = input.split(/[#{Regexp.quote(PROPERTIES_MAP_FILE['sentence-splitters'])}]/)
    sentences = sentences.map{|sentence| sentence.rjust(sentence.length + 1)}
    sentences.each do |sentence|
      NORMAL_SUBSTITUTION_MAP_FILE.each_pair do |key, value|
        sentence.gsub!(/(#{Regexp.quote(key)})/i, value)
      end
    end

    sentences.each_index do |i|
      # Normalize interword spaces and convert to caps
      sentences[i] = sentences[i].split.join(' ').upcase
    end
    puts sentences.inspect
    sentences
  end

  def find_matching_categories(input)
    result = []
    CATEGORIES.each do |category|
      if (category.match_pattern?(input))
        result << category
      end
    end

    result
  end
end
