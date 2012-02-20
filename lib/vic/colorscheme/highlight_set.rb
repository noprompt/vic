module Vic
  class Colorscheme::HighlightSet
    include Enumerable

    def highlights
      @highlights ||= []
    end

    def each
      highlights.each {|h| yield h }
    end

    # Adds a highlight to the set.
    #
    # @param [Colorscheme::Highlight] highlight the highlight to add
    # @return [Colorscheme::HighlightSet] the updated set of highlights
    def add(highlight)
      if highlight.respond_to? :gui
        highlights.push highlight
      else
        # Raise and Exception
        raise TypeError.new("expected type Colorscheme::Vic::Highlight")
      end
    end

    # Find a highlight by group name
    #
    # @params [String] group the group name
    # @retrun [Colorscheme::Highlight,nil] the highlight
    def find_by_group(group)
      find {|h| h.group == group }
    end
  end
end
