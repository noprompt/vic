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
    def update_attributes!(attributes={})
      attributes.each_pair do |key, val|
        self.respond_to?(:"#{ key }=") && send(:"#{ key }=", val)
      end
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
      @force = !! bool
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
      self.ctermbg = Color.new(color).to_cterm
      self.guibg = Color.new(color).to_gui

      # Returning self seems like the right thing to do when a method changes
      # more than one property of an object.
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
      self.ctermfg = Color.new(color).to_cterm
      self.guifg = Color.new(color).to_gui
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
      self.cterm = styles
      self.gui = styles
      self
    end

    attr_accessor :term, :start, :stop

    attr_reader :cterm, :ctermfg, :ctermbg

    # Set the cterm value
    #
    # @param [Array,String,Symbol] styles
    #   the styles to use
    #
    # @return [Array,String,Symbol]
    #   the cterm value
    #
    # @api public
    def cterm=(*styles)
      @cterm = styles.pop
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
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.cterm?
      @ctermbg = color.to_cterm
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
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.cterm?
      @ctermfg = color.to_cterm
    end

    attr_reader :gui, :guibg, :guifg
    attr_accessor :guisp, :font

    # Set the gui value
    #
    # @param [Array,String,Symbol] styles
    #   the styles to use
    #
    # @return [Array,Symbol,Symbol]
    #   the gui value
    #
    # @api public
    def gui=(*styles)
      @gui = styles.pop
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
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.gui?
      @guibg = color.to_gui
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
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.gui?
      @guifg = color.to_gui
    end
  end # class Highlight
end # module Vic
