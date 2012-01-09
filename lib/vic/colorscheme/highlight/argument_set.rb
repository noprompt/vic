module Vic
  class Colorscheme::Highlight::ArgumentSet < Set
    # Adds a new argument to the set
    #
    # @param [Colorscheme::Highlight::Argument] argument the argument to add
    # @return [Colorscheme::Highlight::ArgumentSet] the new set of arguments
    def add(argument)
      if argument.respond_to? :arg
        super(argument)
      else
        # Raise an Exception
      end
    end

    # Finds an argument by a key.
    #
    # @param [String,Symbol] key the key to search for
    # @return [Colorscheme::Highlight::Argument,nil] the new argument
    def find_by_key(key)
      find {|a| a.key.to_s == key.to_s }
    end

    # Sorts the arguments by key name
    #
    # @return [Colorscheme::Highlight::ArgumentSet] the sorted set of arguments
    def sort_by_key
      sort {|a, b| a.key <=> b.key}
    end
  end
end
