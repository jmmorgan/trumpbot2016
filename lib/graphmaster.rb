require 'singleton'

class Graphmaster < GraphmasterNode
  include Singleton

  def initialize(load_aiml_files = true)
    @word_nodes = Set.new
    @category_for_template = {}
    super()
    load_categories if load_aiml_files
  end

  # Adds the given Category to this Graphmaster. If chat_session_id is nil this
  # category is available to all chat sessions. Otherwise it is only available
  # to the chat session having the given ID.
  def add_category(category, chat_session_id = nil)
    tokens = category.pattern.tokens.clone # Cloning array so we don't manipulate array belonging to pattern. # TODO: Refactor so Graphmaster
                                          # doesn't access tokens in Pattern directly (maybe return iterator for Category?)
    current_node = self
    current_token = tokens.shift

    while (current_token)
      current_token.chat_session_id = chat_session_id
      current_node = current_node.find_or_append_child(current_token)
      @word_nodes << current_node if current_node.word?
      current_token = tokens.shift
    end

    current_node = current_node.find_or_append_child(category.that)
    current_node = current_node.find_or_append_child(category.topic)
    current_node = current_node.find_or_append_child(category.template)
    @category_for_template[current_node] ||= category

    self
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    []
  end

  def category_for_template(template)
    @category_for_template[template]
  end

  def word_nodes
    @word_nodes
  end

  private 

  def load_categories
    Dir["#{Rails.root}/lib/aiml/*.aiml"].each do |path|
      #puts "Loading #{path}"
      doc = Nokogiri::XML(File.open(path)) {|config| config.strict}

      doc.xpath('//category[not(ancestor::learn)]').each do |category_element| 
        category = Parsers::CategoryXmlParser.new.parse(category_element, File.basename(path))
        add_category(category)
      end
    end
  end
end
