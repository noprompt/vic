module Vic
  class Highlight
    attr_accessor :group

    def initialize(group, attributes={})
      @group = group
      update_attributes!(attributes)
    end

    def update_attributes!(attributes={})
      attributes.each_pair do |key, val|
        self.respond_to?(:"#{ key }=") && send(:"#{ key }=", val)
      end
    end

    def force=(bool)
      @force = !! bool
    end

    def force?
      @force
    end

    def force!
      @force = true
    end

    def self.attributes
      [:term, :start, :stop, :cterm, :ctermbg, :ctermfg, :gui, :guibg, :guifg, :guisp, :font]
    end

    def fg=(color)
      self.ctermfg = Color.new(color).to_cterm
      self.guifg = Color.new(color).to_gui
    end

    def bg=(color)
      self.ctermbg = Color.new(color).to_cterm
      self.guibg = Color.new(color).to_gui
    end

    def style=(styles)
      self.cterm = styles
      self.gui = styles
    end

    attr_accessor :term, :start, :stop

    attr_reader :cterm, :ctermfg, :ctermbg

    def cterm=(*styles)
      @cterm = styles.pop
    end

    def ctermbg=(color)
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.cterm?
      @ctermbg = color.to_cterm
    end

    def ctermfg=(color)
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.cterm?
      @ctermfg = color.to_cterm
    end

    attr_reader :gui, :guibg, :guifg
    attr_accessor :guisp, :font

    def gui=(*styles)
      @gui = styles.pop
    end

    def guibg=(color)
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.gui?
      @guibg = color.to_gui
    end

    def guifg=(color)
      color = Color.new(color)
      raise ArgumentError.new("invalid color #{ color }") unless color.gui?
      @guifg = color.to_gui
    end
  end # class Highlight
end # module Vic
