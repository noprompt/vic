$:.unshift File.expand_path('../../lib', __FILE__)
require 'vic/highlight'
require 'test/unit'

class HighlightTest < Test::Unit::TestCase
  def test_assigns_valid_arguments
    h = Vic::Highlight.new 'Normal', guibg: '#333333', guifg: '#ffffff'
    assert_equal h.guibg, '#333333'
    assert_equal h.guifg, '#ffffff'
  end

  def test_ignores_invalid_arguments
    h = Vic::Highlight.new 'Normal', satanic: false, agnostic: true
    assert_equal h.send(:arguments), ''
  end

  def test_writes_highlight
    h = Vic::Highlight.new 'Normal', guibg: '#333333', guifg: '#ffffff'
    expected_output = "hi Normal guifg=#ffffff guibg=#333333"
    assert_equal h.write, expected_output
  end
end
