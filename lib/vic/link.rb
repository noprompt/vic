module Vic
  class Link
    attr_accessor :from_group, :to_group

    def initialize(from_group, to_group = :NONE)
      @from_group = from_group
      @to_group = to_group
      @force = false
    end

    # Set the force
    #
    # @param [TrueClass,FalseClass] bool
    #   a value of true or false
    #
    # @return [TrueClass,FalseClass]
    #   the force setting
    #
    # @api public
    def force=(bool)
      @force = !!bool
    end

    # Return the force setting
    #
    # @return [TrueClass,FalseClass]
    #   the force setting
    #
    # @api public
    def force?
      @force
    end

    # Set the force setting to true
    #
    # @return [TrueClass]
    #   the force setting
    #
    # @api public
    def force!
      @force = true
    end
  end # class Link
end # module Vic
