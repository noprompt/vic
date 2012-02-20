module Vic
  class ColorError < StandardError
    def initialize
      super('invalid color')
    end
  end
end
