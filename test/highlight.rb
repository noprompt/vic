$:.unshift File.expand_path('../../lib', __FILE__)
require 'vic'
require 'test/unit'

class HighlightTest < Test::Unit::TestCase
  def test_responds_to_vim_arguments
    highlight = Vic::Colorscheme::Highlight.new('Normal')
    vim_args = %w{term start stop cterm ctermfg ctermbg gui guibg guifg}
    for arg in vim_args
      assert_respond_to highlight, arg
      assert_respond_to highlight, "#{arg}="
    end
  end

  def test_raises_a_type_error_for_arguments
    highlight = Vic::Colorscheme::Highlight.new('Normal')
    assert_raise TypeError do
      highlight.arguments.add 'Soda'
    end
  end
end
