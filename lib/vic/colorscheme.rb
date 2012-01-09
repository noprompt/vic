module Vic
  class Colorscheme
    attr_accessor :colors_name, :information

    # A new instance of Colorscheme. If a block is given with no arguments, the
    # the block will be evaluated in the context of the new colorscheme.
    # Otherwise the block will yield self.
    #
    # @param [String] colors_name the name of the colorscheme
    # @param [Proc] block the block to be evaluated
    # @return [Colorscheme]
    def initialize(colors_name, &block)
      @colors_name = colors_name
      if block_given?
        block.arity == 0 ? instance_eval(&block) : yield(self)
      end
    end

    # Returns/sets the information attribute
    #
    # @param [Hash] information the information, :author => 'Joel Holdbrooks'
    # @return [Hash]
    def information(inf={})
      (@information ||= {}).merge!(inf) if inf.respond_to? :merge
    end
    alias_method :info, :information

    # Returns the background color.
    #
    # @return [String] 'light' or 'dark'
    def background
      @background ||= background!
    end

    # Sets the background color.
    #
    # @param [String] a value of 'light' or 'dark'
    # @return [String] the background attribute
    def background=(light_or_dark)
      unless (light_or_dark =~ /^light$|^dark$/).nil?
        @background = light_or_dark
      end
    end

    # Sets the background color by attempting to determine it.
    #
    # @return[String] the background attribute
    def background!
      @background =
        if normal = highlights.find_by_group('Normal')
          return 'dark' unless color = normal.guibg
          color.partition('#').last.to_i(16) <= 8421504 ? 'dark' : 'light'
        else
          'dark'
        end
    end

    # Returns the set of highlights for the colorscheme
    def highlight_set
      @highlight_set ||= HighlightSet.new
    end
    alias_method :highlights, :highlight_set

    # Creates a new highlight or updates one if it exists.
    #
    # If inside of a language block the langauge name is automatcially prepended
    # to the group name of the new highlight.
    #
    # @see Vic::Highlight
    # @return [Vic::Highlight] the new highlight
    def highlight(group, args={})
      hilight = highlight_set.find_by_group(group)
      no_args = args.empty?

      if not hilight and no_args
        return
      elsif hilight and no_args
        return hilight
      elsif hilight
        hilight.update_arguments!(args)
      else
        hilight = Highlight.new("#{language}#{group}", args)
        highlight_set.add(hilight)
      end

      hilight
    end
    alias_method :hi, :highlight

    # Sets the current language to name. Any new highlights created will have
    # the language name automatically prepended.
    #
    # @return [String] the new language name
    def language=(name)
      @language = name
    end

    # Returns the current language or temporarily sets the language to name if
    # a block is given. If a block is given with no arguments, it will be
    # evaluated in the context of the colorscheme, otherwise it will yield the
    # colorscheme.
    #
    # @param [String,Symbol] name the name of the language
    # @param [Proc] block the block to be evalauted
    # @return [String] the current language
    def language(name=nil, &block)
      if @language and not name
        return @language
      elsif name and block_given?
        previous_language = self.language
        self.language = name
        block.arity == 0 ? instance_eval(&block) : yield(self)
        self.language = previous_language
      end
    end

    # Returns the colorscheme header.
    #
    # @return [String] the colorscheme header
    def header
      <<-EOT.gsub(/^ {6}/, '')
      " Vim color file
      #{info.to_a.map do |pair|
        pair.join(": ").tap {|s| s[0] = '" ' + s[0].upcase }
      end.join("\n")}
      set background=#{background}
      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let g:colors_name="#{colors_name}"
      EOT
    end

    # Returns the colorscheme as a string
    #
    # @return [String] the colorscheme
    def write
      [header, highlights.map(&:write)].join("\n")
    end
  end
end
