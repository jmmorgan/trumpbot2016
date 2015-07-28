class MapFile < Hash

  def initialize(path)
    source = File.read(path)
    array = eval(source)
    array.each do |pair|
      self[pair[0]] = pair[1]
    end
  end
end
