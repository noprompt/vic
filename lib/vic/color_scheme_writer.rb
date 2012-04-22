module Vic
  class ColorSchemeWriter
    def initialize(colorscheme)
      @colorscheme = colorscheme
    end

    def self.write(colorscheme)
      new(colorscheme).write
    end

    def write
      lines = [title, info, background, reset, name, highlights, links]
      "%s\n%s\n\n%s\n\n%s\n%s\n\n%s\n%s" % lines
    end

    private

    def title
      %(" Title: #{ @colorscheme.title })
    end

    def info
      return if @colorscheme.info.empty?
      @colorscheme.info.map do |key, val|
        %(" #{ key }: #{ val })
      end.join("\n")
    end

    def background
      "set background=#{ @colorscheme.background || @colorscheme.background! }"
    end

    def reset
      <<-VIML.gsub(/^ {6}/, '')
      hi clear

      if exists("syntax_on")
        syntax reset
      endif
      VIML
    end

    def name
      %(let g:colors_name="#{ @colorscheme.title }")
    end

    def highlights
      @colorscheme.highlights.map do |highlight|
        attributes = Highlight.attributes.map do |attribute|
          next unless value = highlight.send(attribute)

          case value
          when String, Symbol, Integer
            " #{ attribute }=#{ value }"
          when Array
            " #{ attribute }=#{ value.map(&:to_s).map(&:strip).join(',') }"
          end
        end

        next unless attributes.any?

        if highlight.force?
          "hi! #{ highlight.group }" << attributes.join
        else
          "hi #{ highlight.group }" << attributes.join
        end
      end.compact.join("\n")
    end

    def links
      @colorscheme.links.map do |link|
        if link.force?
          "hi! default link #{ link.from_group } #{ link.to_group }"
        else
          "hi default link #{ link.from_group } #{ link.to_group }"
        end
      end.compact.join("\n")
    end
  end # class ColorSchemeWriter
end # module Vic
