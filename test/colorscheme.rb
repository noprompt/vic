$:.unshift File.expand_path('../../lib', __FILE__)
require 'vic/colorscheme'
require 'vic/highlight'
require 'test/unit'

class ColorschemeTest < Test::Unit::TestCase
  def test_sets_background
    scheme = Vic::Colorscheme.new 'Alligator'
    assert_equal scheme.background, 'dark'
  end

  def test_adds_a_hightlight
    scheme = Vic::Colorscheme.new 'Allan Jackson'
    scheme.hi 'Normal', :guibg => '#333333', :guifg => '#ffffff'
    assert_equal scheme.highlights.pop.class, Vic::Highlight
  end

  def test_updates_background
    scheme = Vic::Colorscheme.new 'Alabama'
    scheme.background
    scheme.hi 'Normal', :guibg => '#ffffff', :guifg => '#333333'
    assert_equal scheme.background!, 'light'
  end

  def test_prepends_language
    scheme = Vic::Colorscheme.new 'All Aboard'
    scheme.language :ruby do
      scheme.hi 'Function', gui: 'bold'
    end
    assert_equal scheme.highlights.pop.group_name, 'rubyFunction'
  end

  def test_writes_header
    scheme = Vic::Colorscheme.new 'Alanis Morissette'
    header =
      <<-EOT.gsub(/^ {6}/, '')
      " Vim color file

      set background=dark
      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let g:colors_name="Alanis Morissette"
      EOT
    assert_equal scheme.header, header
  end

  def test_writes_colorscheme
    scheme = Vic::Colorscheme.new 'Alan Parsons Project'
    scheme.hi 'Normal', guibg: '#333333', guifg: '#ffffff'
    expected_output =
      <<-EOT.gsub(/^ {6}/, '').chomp
      " Vim color file

      set background=dark
      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let g:colors_name="Alan Parsons Project"

      hi Normal guifg=#ffffff guibg=#333333
      EOT
    assert_equal scheme.write, expected_output
  end
end
