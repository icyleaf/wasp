require "json"

struct YAML::Any
  def to_json(json : JSON::Builder)
    case object = @raw
    when Array
      json.array do
        each &.to_json(json)
      end
    when Hash
      json.object do
        each do |key, value|
          json.field key do
            value.to_json(json)
          end
        end
      end
    when "true"
      json.bool(true)
    when "false"
      json.bool(false)
    when Nil
      json.null
    when ""
      json.null
    when /^[+-]?([0-9]*[.])?[0-9]+$/
      object.includes?(".") ? json.number(object.to_f) : json.number(object.to_i)
    else
      json.string(object)
    end
  end
end
