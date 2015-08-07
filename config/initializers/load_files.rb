
# TODO: Replace these global constants with something more encapsulated/object-oriented

# Load properties file
PROPERTIES_MAP_FILE = MapFile.new("#{Rails.root}/lib/system/trump.pdefaults")
PROPERTIES_MAP_FILE.merge!(MapFile.new("#{Rails.root}/lib/system/trump.properties"))

# Load substituion files
NORMAL_SUBSTITUTION_MAP_FILE = MapFile.new("#{Rails.root}/lib/substitutions/normal.substitution")
DENORMAL_SUBSTITUTION_MAP_FILE = MapFile.new("#{Rails.root}/lib/substitutions/denormal.substitution")

# Load AIML files
category_count = 0
trumpified_category_count = 0
GRAPHMASTER = Graphmaster.new
Dir["#{Rails.root}/lib/aiml/*.aiml"].each do |path|
  doc = Nokogiri::XML(File.open(path))

  doc.xpath('//category[not(ancestor::learn)]').each do |category_element| 
    category = Parsers::CategoryXmlParser.new.parse(category_element)
    category_count += 1
    trumpified_category_count += 1 if category.trumpified
    GRAPHMASTER.add_category(category)
  end
end

puts "#{trumpified_category_count} of #{category_count} categories Trumpified."
