module Vic
  class Colorscheme
    attr_accessor :colors_name

    def initialize(colors_name, &block)
      @colors_name = colors_name
      instance_eval(&block) if block_given?
    end

    # Retrieves the background color.
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
        if (normal = highlights.select {|h| h.group_name == 'Normal'}.first)
          return 'dark' unless color = normal.guibg
          color.partition('#').last.to_i(16) <= 8421504 ? 'dark' : 'light'
        else
          'dark'
        end
    end

    # Returns the set of highlights belonging the colorscheme
    #
    # @return[Array] the highlights
    def highlights
      @highlights ||= []
    end

    # Proxy method for `Vim::Highlight#new`. If inside of a language block the
    # langauge name is automatcially prepended to the group name of the new
    # highlight.
    #
    # @see Vim::Highlight
    # @return [Vim::Highlight] the new highlight
    def highlight(group_name, args={}, &block)
      group_name = "#{@language}#{group_name}" if @language
      highlights.push(Highlight.new group_name, args, &block).first
    end
    alias_method :hi, :highlight

    def language(name, &block)
      @language = name
      yield if block_given?
      @language = nil
    end

    def header
      <<-EOT.gsub(/^ {6}/, '')
      " Vim color file

      set background=#{background}
      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let g:colors_name="#{colors_name}"
      EOT
    end

    def write
      [header, highlights.map {|h| h.write }].join("\n")
    end
  end
end
