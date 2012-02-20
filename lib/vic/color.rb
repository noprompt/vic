module Vic
  module Color extend self
    # System colors (0-15)
    SYSTEM_COLORS = [
      [0x00, 0x00, 0x00],
      [0x80, 0x00, 0x00],
      [0x00, 0x80, 0x00],
      [0x80, 0x80, 0x00],
      [0x00, 0x00, 0x80],
      [0x80, 0x00, 0x80],
      [0x00, 0x80, 0x80],
      [0xc0, 0xc0, 0xc0],
      [0x80, 0x80, 0x80],
      [0xff, 0x00, 0x00],
      [0x00, 0xff, 0x00],
      [0xff, 0xff, 0x00],
      [0x00, 0x00, 0xff],
      [0xff, 0x00, 0xff],
      [0x00, 0xff, 0xff],
      [0xff, 0xff, 0xff]
    ]

    # RGB colors (16 - 231)
    RGB_COLORS = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff].repeated_permutation(3).to_a

    # Grayscale colors (232 - 255)
    GRAYSCALE_COLORS = (0x08..0xee).step(0x0a).to_a.map {|v| Array.new(3).fill(v) }

    # All 256 colors of the rainbow. Organized from 0 to 255.
    COLORS_256 = SYSTEM_COLORS + RGB_COLORS + GRAYSCALE_COLORS

    # Convert hexidecimal color to an Array of RGB values.
    #
    # @param [String] hex the hexidecimal color
    # @return [Array] the RGB color conversion
    def hex_to_rgb(hex)
      hex.match(/#?(..)(..)(..)/)[1..4].to_a.map {|v| v.to_i(16) }
    end

    # Takes a hexidecimal color and returns is closest 256 color match.
    #
    # Credit goes to Micheal Elliot for the algorithm which was originally written
    # in Python.
    #
    # @see https://gist.github.com/719710
    # @param [String] hex the hexidecimal color
    # @return [FixNum] the closest 256 color match
    def hex_to_256(hex)
      parts = hex_to_rgb(hex)

      # If the hex is a member of the 256 colors club, we'll just return it's 256
      # color value. No sense in doing extra work, right?
      return COLORS_256.index(parts) if COLORS_256.include?(parts)

      increments = 0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff

      # For each part we need to check if it's between any two of the increments.
      # If it is we'll determine the closest match, change it's value, break,
      # and move on to the next part.
      parts.map! do |part|
        closest = nil
        for i in (0..(increments.length - 1))
          lower = increments[i]
          upper = increments[i + 1]
          next unless (lower <= part) && (part <= upper)
          distance_from_lower = (lower - part).abs
          distance_from_upper = (upper - part).abs
          closest = distance_from_lower < distance_from_upper ? lower : upper
          break
        end
        closest
      end

      # Return the index of the color
      COLORS_256.index(parts)
    end

    # Checks if the subjec is a valid hexidecimal color.
    #
    # @param [String] subject the string in question
    # @return [Match
    def hex_color?(subject)
      subject.match(/#[\da-f]{6}/) ? true : false
    end
  end
end
