class AimlSet < GraphmasterNode
  attr_accessor :name, :set

  def ==(other)
    return other.is_a?(AimlSet) && other.name == @name
  end

  def priority
    5
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    result = nil
    (1..input_tokens.length).each do |i|
      input = input_tokens.slice(0,i)
      if (self.set.include?(input))
        result = input
        break
      end
    end

    result
  end

  def set
    @set ||= load_set
  end

  def to_s
    "<set>#{name}</set>"
  end

  def wildcard?
    true
  end

  private 

  def load_set
    result = Set.new
    path = "#{Rails.root}/lib/sets/#{name}.set" # Rails dependency here.  TODO: Fix later.
    begin
      source = File.read(path) 
      array = eval(source)
      array.each do |item|
        result << item.map(&:upcase)
      end
    rescue => e
      # Just log and fall through for now
      Rails.logger.error "Error loading set from #{path}: #{e}" # Rails dependency here.  TODO: Fix later.
    end
    
    result
  end
end
