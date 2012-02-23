module Vic
  class ColorError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
