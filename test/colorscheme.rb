$:.unshift File.expand_path('../../lib', __FILE__)
require 'vic'
require 'test/unit'

class ColorschemeTest < Test::Unit::TestCase
  def test_adds_a_hightlight
    scheme = Vic::Colorscheme.new 'Allan Jackson'
    scheme.hi 'Normal', :guibg => '#333333', :guifg => '#ffffff'
    assert_kind_of Vic::Colorscheme::Highlight, scheme.hi('Normal')
  end

  def test_sets_background
    scheme = Vic::Colorscheme.new 'Alligator'
    assert_equal scheme.background, 'dark'
  end

  def test_updates_background
    scheme = Vic::Colorscheme.new 'Alabama'
    scheme.background
    scheme.hi 'Normal', :guibg => '#ffffff', :guifg => '#333333'
    scheme.background!
    assert_equal 'light', scheme.background
  end

  def test_adds_and_returns_info
    scheme = Vic::Colorscheme.new 'Alabama'
    scheme.info[:author] = 'Joel Holdbrooks'
    scheme.info[:homepage] = 'http://github.com/noprompt/vic'
    assert_respond_to scheme.info, 'merge'
    assert scheme.info[:author], 'Joel Holdbrooks'
    assert scheme.info[:homepage], 'http://github.com/noprompt/vic'
  end

  def test_prepends_language
    scheme = Vic::Colorscheme.new 'All Aboard'
    scheme.language :ruby do
      hi 'Function', gui: 'bold'
      scheme.language :python do
        hi 'String', gui: 'italic'
      end
    end
    assert scheme.hi('rubyFunction')
    assert scheme.hi('pythonString')
  end

  def test_writes_header
    scheme = Vic::Colorscheme.new 'Alanis Morissette'
    scheme.info :author => 'Joel Holdbrooks'
    header =
      <<-EOT.gsub(/^ {6}/, '')
      " Vim color file
      " Author: Joel Holdbrooks
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

      hi Normal guibg=#333333 guifg=#ffffff
      EOT
    assert_equal scheme.write, expected_output
  end
end
