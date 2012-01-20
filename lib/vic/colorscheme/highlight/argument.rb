module Vic
  class Colorscheme::Highlight::Argument
    VALID = %w{term start stop cterm ctermfg ctermbg gui guifg guibg guisp font}

    attr_accessor :key, :arg

    def initialize(key, arg)
      @key, @arg = key, arg
    end

    # The argument as a string
    #
    # @return [String,nil] the string if argument has been set
    def write
      return unless arg
      "#{key}=#{arg.respond_to?(:join) ? arg.join(',') : arg}"
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
