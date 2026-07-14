require 'tins/deep_transform'

module Tins
  class ::Hash
    include DeepTransform
  end

  class ::Array
    include DeepTransform
  end
end
