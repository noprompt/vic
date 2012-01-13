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
      @group = group
      update_arguments!(args)
    end

    # Sets the methods term, term=, start, start=, etc. for settings arguments.
    self.class_eval do
      %w{term start stop cterm ctermfg ctermbg gui guibg guifg}.each do |m|
        define_method(m) {
          argument = argument_set.find_by_key(m)
          return argument.arg if argument
        }
        define_method("#{m}=") {|val|
          argument = argument_set.find_by_key(m)
          if argument
            argument.arg = val
          else
            argument = Argument.new(m, val)
            argument_set.add argument
          end
          val
        }
      end
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
      "hi #{group} #{arguments.sort_by_key.map(&:write).join(' ')}"
    end
  end
end
