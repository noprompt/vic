module Vic
  class Colorscheme::Highlight

    attr_accessor :group

    # Creates an instance of Vic::Colorscheme::Highlight. Uses
    # `update_arguments!` to set the arguments.
    #
    # @param [String] group the group name, 'Normal', 'Function', etc.
    # @param [Hash] args the arguments to set
    # @return [Vic::Colorscheme::Highlight] the new highlight
    def initialize(group, args={})
      # Convert to group name to symbol to ensure consistency
      @group = group.to_sym
      update_arguments!(args)
    end

    # Sets the methods term, term=, start, start=, etc. for settings arguments.
    self.class_eval do
      %w{term start stop cterm ctermfg ctermbg gui guifg guibg}.each do |m|

        # Getter method
        define_method(m) do
          arg = argument_set.find_by_key(m)
          return arg.val if arg
        end

        # Setter method
        define_method("#{m}=") do |val|
          arg = argument_set.find_by_key(m)
          if arg
            arg.val = val
          else
            arg = Argument.new(m, val)
            argument_set.add arg
          end
        end
      end
    end

    # Sets guifg and ctermfg simultaneously. `hex` is automatically converted to
    # the 256 color code for ctermfg.
    #
    # @param [String] hex a hexidecimal color
    def fg=(color)
      if color =~ /none/i
        self.ctermfg = color
      elsif Color.is_hexadecimal?(color)
        self.ctermfg = Color.hex_to_256(color)
      else
        raise ColorError.new "invalid hexadecimal color #{color}"
      end

      self.guifg = color
    end

    # Sets guibg and ctermbg simultaneously. `hex` is automatically converted to
    # the 256 color code for ctermbg.
    #
    # @param [String] hex a hexidecimal color
    def bg=(color)
      if color =~ /none/i
        self.ctermbg = color.upcase
      elsif Color.is_hexadecimal?(color)
        self.ctermbg = Color.hex_to_256(color)
      else
        raise ColorError.new "invalid hexadecimal color #{color}"
      end

      self.guibg = color
    end

    # Updates/sets the current highlight's arguments.
    #
    # @param [Hash] args the arguments to update/set, `:guibg => '#333333'`
    # @return [Vic::Colorscheme::Highlight::ArgumentSet] the updated argument set
    def update_arguments!(args={})
      args.each {|key, val| send("#{key}=", val)}
      arguments
    end

    # Returns the set of arguments for the given highlight
    #
    # @return [Vic::Colorscheme::Highlight::ArgumentSet] the argument set
    def argument_set
      @argument_set ||= ArgumentSet.new
    end
    alias_method :arguments, :argument_set

    # Writes the highlight contents.
    #
    # @return [String] the highlight as a string
    def write
      "hi #{group} #{arguments.sort_by_key.map(&:write).compact.join(' ')}"
    end
  end
end
