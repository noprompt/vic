module Vic
  class Colorscheme::Highlight::Argument
    VALID = %w{term start stop cterm ctermfg ctermbg gui guifg guibg guisp font}

    attr_accessor :key, :val

    def initialize(key, val)
      @key, @val = key, val
    end

    # The argument as a string
    #
    # @return [String,nil] the string if argument has been set
    def write
      return unless val
      "#{key}=#{val.respond_to?(:join) ? val.join(',') : val}"
    end

    # Checks if `key` is valid vim key for an argument
    #
    # @param [String,Symbol]
    # @return [true,false] the key is valid
    def self.is_valid?(key)
      VALID.include?(key.to_s)
    end
  end
end
