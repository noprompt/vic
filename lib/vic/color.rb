module Vic
  class Color
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    class ColorError < RuntimeError; end

    # Convert the color value to a hexadecimal color
    #
    # @return [Symbol,String]
    #   the color as either "NONE" or hexadecimal
    #
    # @api public
    def to_gui
      return to_standard_hex if hexadecimal?
      return Convert.xterm_to_hex(@value) if cterm?
      return :NONE if none?

      raise ColorError.new "can't convert \"#{ @value }\" to gui"
    end

    # Convert the color value to a cterm compatible color
    #
    # @return [Fixnum]
    #   the color as either "NONE" or cterm color
    #
    # @api public
    def to_cterm
      return @value if cterm?
      return Convert.hex_to_xterm(to_standard_hex) if hexadecimal?
      return :NONE if none?

      raise ColorError.new "can't convert \"#{ @value }\" to cterm"
    end

    # Returns true if the color value is cterm compatible color and false if
    # it's not
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is cterm compatible
    #
    # @api public
    def cterm?
      @value.kind_of?(Fixnum) and @value.between?(0, 255)
    end

    # Returns true if the color value is a gui compatible color and false if
    # it's not
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is gui compatible
    #
    # @api public
    def gui?
      hexadecimal?
    end

    # Returns true if the color value is a hexadecimal color and false if it's not
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is hexadecimal
    #
    # @api public
    def hexadecimal?
      # Both standard and shorthand (CSS) style hexadecimal color value.
      not cterm? and /\A#?(?:[0-9a-f]{3}|[0-9a-f]{6})\z/io.match(@value.to_s)
    end

    # Returns true if the color value is either empty or set to "NONE"
    #
    # @return [TrueClass,FalseClass]
    #   whether or not the color value is empty or "NONE"
    #
    # @api public
    def none?
      @value.to_s.empty? or /\Anone\z/io.match(@value.to_s)
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
