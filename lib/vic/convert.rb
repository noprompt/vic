module Vic
  module Convert
    def self.hex_to_rgb(hex)
      hex.match(/#?(..)(..)(..)/).captures.map { |v| v.to_i(16) }
    end

    def self.hex_to_xterm(hex)
      rgb = hex_to_rgb(hex)

      return XtermColor.table.index(rgb) if XtermColor.table.include?(rgb)

      increments = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]

      rgb.map! do |part|
        for i in (0...5)
          lower, upper = increments[i], increments[i + 1]

          next unless part.between?(lower, upper)

          distance_from_lower = (lower - part).abs
          distance_from_upper = (upper - part).abs
          closest = distance_from_lower < distance_from_upper ? lower : upper
        end
        closest
      end
      XtermColor.table.index(rgb)
    end

    def self.xterm_to_hex(code)
      '#' + XtermColor.table[code].map { |v| (v.to_s(16) * 2)[0...2] }.join
    end
  end # module Convert
end # module Vic
