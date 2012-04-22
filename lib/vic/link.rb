module Vic
  class Link
    attr_accessor :from_group, :to_group

    def initialize(from_group, to_group = :NONE)
      @from_group = from_group
      @to_group = to_group
      @force = false
    end

    def force=(bool)
      @force = !! bool
    end

    def force?
      @force
    end

    def force!
      @force = true
    end
  end # class Linke
end # module Vic
