$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'vic'

module Vic
  class TestColorScheme < MiniTest::Unit::TestCase

    def setup
      @colorscheme = Vic::ColorScheme.new 'Alabama'
    end

    def test_it_creates_forced_highlights
      @colorscheme.hi! :Normal
      assert @colorscheme.highlights.first.force?
    end

    def test_it_updates_highlights
      h1 = @colorscheme.hi! :Normal
      h2 = @colorscheme.hi :Normal, fg: '000'
      assert_equal h1, h2
      assert_equal h1.guifg, h2.guifg
    end

    def test_it_creates_links
      @colorscheme.link :Foo, :Bar, :Baz
      assert_equal :Foo, @colorscheme.links.first.from_group
      assert_equal :Bar, @colorscheme.links.last.from_group
      assert_equal :Baz, @colorscheme.links.first.to_group
      assert_equal :Baz, @colorscheme.links.last.to_group
    end

    def test_it_creates_unique_links
      @colorscheme.link :Foo, :Bar, :Baz
      @colorscheme.link :Foo, :Bar, :Baz
      assert_equal 2, @colorscheme.links.count
    end

    def test_it_creates_forced_links
      @colorscheme.link! :Foo, :Bar
      assert @colorscheme.links.first.force?
    end

    def test_it_prepends_a_language
      @colorscheme.language = :ruby
      @colorscheme.hi :Block
      assert_equal :rubyBlock, @colorscheme.highlights.first.group
    end

    def test_it_prepends_a_language_in_block
      @colorscheme.language :ruby do
        hi :Block
        language :python do
          hi :Function
        end
        hi :Function
      end

      # Ensure nothing is prepended when we leave the block.
      @colorscheme.hi :Normal

      assert_equal :rubyBlock, @colorscheme.highlights[0].group
      assert_equal :rubyFunction, @colorscheme.highlights[2].group
      assert_equal :pythonFunction, @colorscheme.highlights[1].group
      assert_equal :Normal, @colorscheme.highlights[3].group
    end

    def test_it_renders_a_colorscheme
      @colorscheme.info = { Author: 'Joel Holdbrooks <cjholdbrooks@gmail.com>', URI: 'http://github.com/noprompt' }
      @colorscheme.hi! :Normal, bg: 'fff', fg: '000'
      @colorscheme.hi! :Foo, style: %w(bold italic)
      @colorscheme.link! :Bar, :Baz, :Quux

      result = <<-VIML.gsub(/^ {6}/, '').chomp
      " Title: Alabama
      " Author: Joel Holdbrooks <cjholdbrooks@gmail.com>
      " URI: http://github.com/noprompt

      set background=light

      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let g:colors_name="Alabama"

      hi! Normal ctermbg=15 ctermfg=0 guibg=#ffffff guifg=#000000
      hi! Foo cterm=bold,italic gui=bold,italic
      hi! default link Bar Quux
      hi! default link Baz Quux
      VIML

      assert_equal result, @colorscheme.render
    end

    def test_it_renders_a_colorscheme_in_a_block
      colorscheme = Vic::ColorScheme.new 'Alabama' do
        add_info Author: 'Joel Holdbrooks <cjholdbrooks@gmail.com>'
        add_info URI: 'http://github.com/noprompt'
        hi! :Normal, bg: 'fff', fg: '000'
        hi! :Foo, style: %w(bold italic)
        link! :Bar, :Baz, :Quux
      end

      result = <<-VIML.gsub(/^ {6}/, '').chomp
      " Title: Alabama
      " Author: Joel Holdbrooks <cjholdbrooks@gmail.com>
      " URI: http://github.com/noprompt

      set background=light

      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let g:colors_name="Alabama"

      hi! Normal ctermbg=15 ctermfg=0 guibg=#ffffff guifg=#000000
      hi! Foo cterm=bold,italic gui=bold,italic
      hi! default link Bar Quux
      hi! default link Baz Quux
      VIML

      assert_equal result, colorscheme.render
    end

  end # class TestColorscheme
end # module Vic
