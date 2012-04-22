module Vic
  class Color
    def initialize(value)
      @value = value.to_s
    end

    def to_gui
      return :NONE if none?
      return to_standard_hex if hexadecimal?
      Convert.xterm_to_hex(@value.to_i)
    end

    def to_cterm
      return :NONE if none?
      return @value if cterm?
      Convert.hex_to_xterm(to_standard_hex)
    end

    def cterm?
      # A value between 0 and 255.
      !!/\A(?:1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\z/i.match(@value)
    end

    def gui?
      hexadecimal? or none?
    end

    def hexadecimal?
      # Both standard and shorthand (CSS) style hexadecimal color value.
      !!/\A#?(?:[0-9a-f]{3}|[0-9a-f]{6})\z/i.match(@value)
    end

    def none?
      @value.empty? or /\Anone\z/i.match(@value)
    end

    private

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
