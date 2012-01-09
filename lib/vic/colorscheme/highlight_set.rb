module Vic
  class Colorscheme::HighlightSet < Set
    # Adds a highlight to the set.
    #
    # @param [Colorscheme::Highlight] highlight the highlight to add
    # @return [Colorscheme::HighlightSet] the updated set of highlights
    def add(highlight)
      if highlight.respond_to?(:group)
        super(highlight)
      else
        # Raise and Exception
      end
    end

    def find_by_group(group)
      find {|h| h.group == group }
    end
  end
end
