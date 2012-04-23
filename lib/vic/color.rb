module Vic
  class Color
    def initialize(value)
      @value = value.to_s
    end

    # Convert the color value to a hexadecimal color
    #
    # @return [Symbol,String]
    #   the color as either "NONE" or hexadecimal
    #
    # @api public
    def to_gui
      return :NONE if none?
      return to_standard_hex if hexadecimal?
      Convert.xterm_to_hex(@value.to_i)
    end

    # Convert the color value to a cterm compatible color
    #
    # @return [Fixnum]
    #   the color as either "NONE" or cterm color
    #
    # @api public
    def to_cterm
      return :NONE if none?
      return @value if cterm?
      Convert.hex_to_xterm(to_standard_hex)
    end

    # Returns true if the color value is cterm compatible color and false if
    # it's not
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is cterm compatible
    #
    # @api public
    def cterm?
      # A value between 0 and 255.
      !!/\A(?:1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\z/i.match(@value)
    end

    # Returns true if the color value is a gui compatible color and false if
    # it's not
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is gui compatible
    #
    # @api public
    def gui?
      hexadecimal? or none?
    end

    # Returns true if the color value is a hexadecimal color and false if it's not
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is hexadecimal
    #
    # @api public
    def hexadecimal?
      # Both standard and shorthand (CSS) style hexadecimal color value.
      !!/\A#?(?:[0-9a-f]{3}|[0-9a-f]{6})\z/i.match(@value)
    end

    # Returns true if the color value is either empty or set to "NONE"
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is empty or "NONE"
    #
    # @api public
    def none?
      @value.empty? or /\Anone\z/i.match(@value)
    end

    private

    # Convert the color value to a standard hexadecimal value
    #
    # @example
    #   Color.new('333').send(:to_standard_hex) # => '#333333'
    #
    # @return [String]
    #   the color in standard hexadecimal format
    #
    # @api private
    def to_standard_hex
      color = @value.dup
      color.insert(0, '#') unless color.start_with? '#'

      # Convert shorthand hex to standard hex.
      if color.size == 4
        color.slice!(1, 3).chars { |char| color << char * 2 }
      end
      color
    end
  end # class Color
end # module Vic
