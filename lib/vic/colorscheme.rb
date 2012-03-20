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

    # Returns the background setting.
    #
    # @return [String] 'light' or 'dark'
    def background
      @background ||= background!
    end

    # Sets the background.
    #
    # @param [String] a value of 'light' or 'dark'
    # @return [String] the background attribute
    def background=(setting)
      unless setting =~ /^light$|^dark$/
        raise "background setting must be either 'light' or 'dark'"
      end
      @background = setting
    end

    # Sets the background by attempting to determine it.
    #
    # @return[String] the background attribute
    def background!
      normal = find_highlight 'Normal'
      unless normal && normal.guibg
        return @background = 'dark'
      end
      hex = normal.guibg.match(/[a-f0-9]{6}/i)[0]
      @background = hex.to_i(16) <= 8421504 ? 'dark' : 'light'
    end

    # Returns the set of highlights for the colorscheme
    def highlights
      @highlights ||= HighlightSet.new
    end

    # Creates a new highlight
    #
    # If inside of a language block the langauge name is automatcially prepended
    # to the group name of the new highlight.
    #
    # @see Vic::Highlight
    # @return [Vic::Highlight] the new highlight
    def highlight(group, args={})
      return if args.empty?

      if h = find_highlight(group)
        h.update_arguments! args
      else
        h = Highlight.new "#{language}#{group}", args
        highlights.add h
      end
    end
    alias_method :hi, :highlight

    def find_highlight(group)
      highlights.find_by_group(group)
    end

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
