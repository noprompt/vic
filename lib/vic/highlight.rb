module Vic
  class Highlight

    attr_accessor :group

    def initialize(group, attributes={})
      @group = group
      update_attributes!(attributes)
    end

    # Updates the highlights attributes
    #
    # @example
    #   h = Vic::Highlight.new('Normal', { guibg: '333' })
    #   h.guibg # => "#333333"
    #   h.update_attributes!({ guibg: '000' })
    #   h.guibg # => "#000000"
    #
    # @param [Hash] attributes
    #   the attributes to update
    #
    # @return [Vic::Highlight]
    #   the updated highlight
    #
    # @api public
    def update_attributes!(attributes={})
      attributes.each_pair do |key, val|
        self.respond_to?(:"#{ key }=") && send(:"#{ key }=", val)
      end

      # Returning self seems like the right thing to do when a method changes
      # more than one property of an object.
      self
    end

    # Return the list of highlight attributes
    #
    # @return [Array]
    #   the list of highlight attributes
    #
    # @api semipublic
    def self.attributes
      [:term, :start, :stop, :cterm, :ctermbg, :ctermfg, :gui, :guibg, :guifg, :guisp, :font]
    end

    # Set the force
    #
    # @param [TrueClass,FalseClass] bool
    #   a value of true or false
    #
    # @return [TrueClass,FalseClass]
    #   the force setting
    #
    # @api public
    def force=(bool)
      @force = !!bool
    end

    # Return the force setting
    #
    # @return [TrueClass,FalseClass]
    #   the force setting
    #
    # @api public
    def force?
      @force
    end

    # Set the force setting to true
    #
    # @return [TrueClass]
    #   the force setting
    #
    # @api public
    def force!
      @force = true
    end

    # Set both ctermbg and guibg simultaneously
    #
    # @param [String] color
    #   the color to use
    #
    # @return [Vic::Highlight]
    #   the updated highlight
    #
    # @api public
    def bg=(color)
      color = Color.new(color)
      @ctermbg, @guibg = color.to_cterm, color.to_gui
      self
    end

    # Set both ctermfg and guifg simultaneously
    #
    # @param [String] color
    #   the color to use
    #
    # @return [Vic::Highlight]
    #   the updated highlight
    #
    # @api public
    def fg=(color)
      color = Color.new(color)
      @ctermfg, @guifg = color.to_cterm, color.to_gui
      self
    end

    # Set both cterm and gui simultaneously
    #
    # @param [Array] styles
    #   the styles to use
    #
    # @return [Vic::Highlight]
    #   the updated highlight
    #
    # @api public
    def style=(styles)
      @cterm, @gui = [select_styles(styles)] * 2
      self
    end

    attr_accessor :term, :start, :stop

    attr_reader :cterm, :ctermfg, :ctermbg

    # Set the cterm value
    #
    # @param [Array,String,Symbol] styles
    #   the styles to use
    #
    # @return [Array,Symbol]
    #   the cterm value
    #
    # @api public
    def cterm=(*styles)
      @cterm = select_styles(styles)
    end

    # Set the ctermbg value
    #
    # @param [String,Symbol] color
    #   the color to use
    #
    # @return [String,Symbol]
    #   the ctermbg color
    #
    # @api public
    def ctermbg=(color)
      @ctermbg = Color.new(color).to_cterm
    end

    # Set the ctermfg value
    #
    # @param [String,Symbol] color
    #   the color to use
    #
    # @return [String,Symbol]
    #   the ctermfg color
    #
    # @api public
    def ctermfg=(color)
      @ctermfg = Color.new(color).to_cterm
    end

    attr_reader :gui, :guibg, :guifg
    attr_accessor :guisp, :font

    # Set the gui value
    #
    # @param [Array,String,Symbol] styles
    #   the styles to use
    #
    # @return [Array,Symbol]
    #   the gui value
    #
    # @api public
    def gui=(*styles)
      @gui = select_styles(styles)
    end

    # Set the guibg value
    #
    # @param [String,Symbol] color
    #   the color to use
    #
    # @return [String,Symbol]
    #   the guibg color
    #
    # @api public
    def guibg=(color)
      @guibg = Color.new(color).to_gui
    end

    # Set the guifg value
    #
    # @param [String,Symbol] color
    #   the color to use
    #
    # @return [String,Symbol]
    #   the guifg color
    #
    # @api public
    def guifg=(color)
      @guifg = Color.new(color).to_gui
    end

    private

    # Valid font styles *excluding* none
    FONT_STYLE = /bold|(under(line|curl))|((re|in)verse)|italic|standout/o

    # Selcect valid styles from a list
    #
    # @param [Mixed] styles
    #   the list of styles
    #
    # @return [Array,Symbol]
    #   the list of valid styles or "NONE"
    #
    # @api private
    def select_styles(*styles)
      styles.tap(&:compact).flatten!
      if styles.empty? or styles.length == 1 && /\Anone\z/io.match(styles[0])
        return :NONE
      end
      styles.select { |s| FONT_STYLE.match(s) }
    end
  end # class Highlight
end # module Vic
