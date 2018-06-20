
struct YAML::Any
  def to_json(json : JSON::Builder)
    @raw.to_json(json)
  end
end

struct Slice
  def to_json(json : JSON::Builder)
    {% if T != UInt8 %}
      {% raise "Can only serialize Slice(UInt8), not #{@type}}" %}
    {% end %}

    json.string(self)
  end
end
