module Tins
  module StringNamedPlaceholders
    def named_placeholders
      scan(/%\{([^}]+)\}/).inject([], &:concat).uniq.map(&:to_sym)
    end

    def named_placeholders_assign(hash, default: nil)
      hash = hash.transform_keys(&:to_sym)
      named_placeholders.each_with_object({}) do |placeholder, h|
        h[placeholder] = hash[placeholder] ||
          (default.is_a?(Proc) ? default.(placeholder) : default)
      end
    end
  end
end
