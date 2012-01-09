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

    # Returns and/or sets an argument for the current highlight.
    #
    # @param [String,Symbol] the argument key
    # @param [String,Array,nil] the values to assign to the argument key
    # @return [String,Symbol,Array,nil] the value of the argument key
    def method_missing(key, *args)
      super unless key =~ (/([a-z]+)=?/) and Argument.is_valid?($1)
      lookup   = $1.to_s
      argument = argument_set.find_by_key(lookup)
      args     = args.first if args.first.respond_to? :chr

      if not argument and args.empty?
        return
      elsif argument and not args.empty?
        argument.arg = args
      elsif argument and args.empty?
        return argument.arg
      elsif not args.empty?
        argument = Argument.new(lookup, args)
        arguments.add argument
      end
      argument.arg
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
