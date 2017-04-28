require "json"

struct JSON::Any
  def []=(key : String, value : String)
    @raw[key] = value.as(JSON::Type)
  end
  #
  # def []=(key : JSON::Type, value : Int64)
  #   @raw[key] = value.as(JSON::Type)
  # end
  #
  # def []=(key : JSON::Type, value : Bool)
  #   @raw[key] = value.as(JSON::Type)
  # end
  #
  # def []=(key : JSON::Type, value : Float64)
  #   @raw[key] = value.as(JSON::Type)
  # end
end
