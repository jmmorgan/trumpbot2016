# Class should be initialized with a request parameter of type String, representing the input text.
# #call will return a string where all names in the input string with associated Twitter handles
# will be replaced by their respective Twitter handles.
class Interactors::TransformNamesToTwitterHandles < Interactor

  def call
    result = request
    _map = map
    map.each_pair do |k,v|
      result = result.gsub(/\b#{Regexp.quote(k)}\b/i, v)
    end

    result
  end

  private

  def map
    # Hard coding path here for now
    @@map ||= MapFile.new("#{Rails.root}/lib/maps/name2twitterhandle.map")
  end
end
