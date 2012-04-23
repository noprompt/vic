module Vic
  class ColorScheme
    attr_accessor :title

    def initialize(title, &block)
      @title = title
      @highlights = []
      @links = []
      @info = OpenStruct.new

      if block_given?
        block.arity.zero? ? instance_eval(&block) : yield(self)
      end
    end

    # Return the colorscheme information
    #
    # @return [Hash]
    #   the colorscheme information
    #
    # @api public
    def info
      @info.marshal_dump
    end

    # Set the colorscheme information
    #
    # @param [Hash] data
    #   the data to use
    #
    # @return [Hash]
    #   the colorscheme information
    #
    # @api public
    def info=(data = {})
      @info.marshal_load(data)
    end

    # Updates the colorscheme information
    #
    # @param [Hash] data
    #   the data to use
    #
    # @return [Hash]
    #   the colorscheme information
    #
    # @api public
    def add_info(data = {})
      self.info = @info.marshal_dump.merge(data)
    end

    # Return the background setting
    #
    # @return [NilClass,String,Symbol]
    #   the background setting
    def background
      @background
    end

    # Sets the background
    #
    # @param [String,Symbol] setting
    #   a background setting of either "light" or "dark"
    #
    # @return [String,Symbol]
    #   the background setting
    #
    # @api public
    def background=(setting)
      unless /\A(light|dark)\z/o.match(setting)
        raise ArgumentError.new("expected 'light' or 'dark'")
      end
      @background = setting
    end

    # Sets the background automatically
    #
    # By default this will return "dark". If a highlight with the `group`
    # "Normal" and a `guibg` setting has been added to the colorscheme, it will
    # determine the setting to use. If the `guibg` is strictly less than
    # "#808080" the background will be set to "dark" otherwise it will be set
    # to "light".
    #
    # @return [String]
    #   the background setting
    #
    # @api public
    def background!
      normal = find_highlight(:Normal)
      return @background = 'dark' unless normal && normal.guibg
      @background = normal.guibg[1..-1].to_i(16) < 8421504 ? 'dark' : 'light'
    end

    # Return the colorscheme's highlights
    #
    # @return [Array]
    #   the colorscheme's highlights
    #
    # @api public
    def highlights
      @highlights.dup
    end

    # Add or update a highlight
    #
    # @example
    #   scheme.highlight(:Normal, fg: 'eee', bg: '333')
    #
    # @param [String,Symbol] group
    #   the group to highlight
    #
    # @param [Hash] attributes
    #   the attributes to set or update
    #
    # @return [Vic::Highlight]
    #   the highlight
    #
    # @api public
    def highlight(group, attributes={})
      if hilight = find_highlight(group)
        hilight.update_attributes!(attributes)
      else
        hilight = Highlight.new(:"#{ language }#{ group }", attributes)
        @highlights << hilight
      end

      hilight
    end
    alias_method :hi, :highlight

    # Add or update a forced highlight
    #
    # @example
    #   scheme.highlight!(:Normal, fg: 'eee', bg: '333').force? # => true
    #
    # @param [Hash] attributes
    #   the attributes to set or update
    #
    # @return [Vic::Highlight]
    #   the highlight
    #
    # @api public
    def highlight!(group, attributes={})
      highlight(group, attributes.dup.tap { |hash| hash[:force] = true })
    end
    alias_method :hi!, :highlight!

    # Return the colorscheme's links
    #
    # @return [Array]
    #   the colorscheme's links
    #
    # @api public
    def links
      @links.dup
    end

    # Add highlight links to the colorscheme
    #
    # @example
    #   scheme.link(:rubyInstanceVariable, :rubyClassVariable)
    #
    # @param [String,Symbol] from_groups
    #   a list of groups to link from
    #
    # @param [String,Symbol] to_groups
    #   the group to link to
    #
    # @return [Array]
    #   the added links
    #
    # @api public
    def link(*from_groups, to_group)
      from_groups.flatten.map do |from_group|
        # Don't add anything we don't already have.
        next if @links.find do |l|
          l.from_group == from_group and l.to_group == to_group
        end
        link = Link.new(from_group, to_group)
        link.tap { |l| @links << l }
      end.compact
    end

    # Add forced highlight links to the colorscheme
    #
    # @example
    #   scheme.link!(:rubyInstanceVariable, :rubyClassVariable)
    #   link = scheme.links.find do |l|
    #     l.from_group == :rubyInstanceVariable and l.to_group = :rubyClassVariable
    #   end
    #   link.force? # => true
    #
    # @param [String,Symbol] from_groups
    #   a list of groups to link from
    #
    # @param [String,Symbol] to_groups
    #   the group to link to
    #
    # @return [Array]
    #   the added/updated links
    #
    # @api public
    def link!(*from_groups, to_group)
      # Use the default method first.
      self.link(from_groups, to_group)

      # Then update the links.
      from_groups.flatten.map do |from_group|
        link = @links.find do |l|
          l.from_group == from_group and l.to_group == to_group
        end
        link.tap(&:force!)
      end
    end

    # Set a language to prepend new highlight group names with
    #
    # @example
    #   scheme.language = :ruby
    #   scheme.hi(:InstanceVariable).group == :rubyInstanceVariable # => true
    #
    # @param [String,Symbol] name
    #   the language name
    #
    # @return [String,Symbol]
    #   the language name
    #
    # @api public
    def language=(name)
      @language = name
    end

    # Return the language
    #
    # If a name and a block is passed the language will be temporarily set to
    # name inside the block.
    #
    # @example
    #   scheme.language :ruby do |s|
    #     s.hi(:InstanceVariable)
    #     s.hi(:ClassVariable)
    #   end
    #   scheme.highlights.any? { |h| h.group == :rubyClassVarible } # => true
    #
    # @param [String,Symbol] name
    #   the language to temporarily set if a block is given
    #
    # @yieldparam [Vic::Colorscheme]
    #   the colorscheme
    #
    # @return [String,Symbol]
    #   the language setting
    #
    # @api public
    def language(name = nil, &block)
      return @language unless name and block_given?

      previous_language = self.language
      @language = name
      block.arity == 0 ? instance_eval(&block) : yield(self)
      @language = previous_language
    end

    # Render the colorscheme
    #
    # @return [String]
    #   the colorscheme as a string
    #
    # @api public
    def render
      ColorSchemeWriter.write(self)
    end

    private

    # Find a highlight
    #
    # @param [String,Symbol] group
    #   the highlight group to find
    #
    # @return [NilClass,Vic::Highlight]
    #   the found highlight
    #
    # @api private
    def find_highlight(group)
      highlights.find { |h| /\A#{ group }\z/.match h.group }
    end
  end # class ColorScheme
end # module Vic
