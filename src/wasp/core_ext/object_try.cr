module Wasp
  module Tryable
    def try_fetch(key, default_value = "")
      return default_value if !self || self.nil?
      return default_value unless self.has_key?(key)

      return fetch(key)
    end
  end
end

# :nodoc:
class Hash(K, V)
  include Wasp::Tryable
end
