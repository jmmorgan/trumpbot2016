
# TODO: Replace these global constants with something more encapsulated/object-oriented

# Load properties file
PROPERTIES_MAP_FILE = MapFile.new("#{Rails.root}/lib/system/trump.properties")

# Load substituion files
NORMAL_SUBSTITUTION_MAP_FILE = MapFile.new("#{Rails.root}/lib/substitutions/normal.substitution")

# Load AIML files
GRAPHMASTER = Graphmaster.new
Dir["#{Rails.root}/lib/aiml/*.aiml"].each do |path|
  doc = Nokogiri::XML(File.open(path))

  doc.xpath('//category').each do |category| 
    GRAPHMASTER.add_category(Parsers::CategoryXmlParser.new.parse(category))
  end
end
