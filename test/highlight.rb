$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'vic'

module Vic
  class TestHighlight < MiniTest::Unit::TestCase
    def setup
      @highlight = Vic::Highlight.new('Normal')
    end

    def test_it_updates_attributes
      @highlight.guibg = "#333333"
      @highlight.update_attributes!(guibg: "#000000")
      assert_equal '#000000', @highlight.guibg
    end

    def test_it_forces
      @highlight.force!
      assert @highlight.force?
    end

    def test_it_sets_both_ctermbg_and_guibg
      @highlight.fg = '000'
      assert_equal '#000000', @highlight.guifg
      assert_equal 0, @highlight.ctermfg
    end

    def test_it_sets_both_ctermfg_and_guifg
      @highlight.fg = 'fff'
      assert_equal '#ffffff', @highlight.guifg
      assert_equal 15, @highlight.ctermfg
    end

    def test_it_sets_both_cterm_and_gui
      @highlight.style = 'bold', 'italic'
      assert_equal ['bold', 'italic'], @highlight.cterm
      assert_equal ['bold', 'italic'], @highlight.gui
    end

    def test_it_raises_an_error
      assert_raises(Vic::Color::ColorError) { @highlight.ctermbg = 'lol' }
      assert_raises(Vic::Color::ColorError) { @highlight.ctermfg = 'omg' }
      assert_raises(Vic::Color::ColorError) { @highlight.guibg = 'hai' }
      assert_raises(Vic::Color::ColorError) { @highlight.guifg = 'bai' }
    end
  end # class TestHighlight
end # module Vic
