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
end
