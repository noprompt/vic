$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'vic'

module Vic
  class TestColor < MiniTest::Unit::TestCase
    def test_it_converts_a_color_to_gui
      color = Color.new(0)
      assert_equal '#000000', color.to_gui

      color = Color.new(15)
      assert_equal '#ffffff', color.to_gui
    end

    def test_it_converts_a_color_to_cterm
      color = Color.new('#000000')
      assert_equal 0, color.to_cterm

      color = Color.new('#ffffff')
      assert_equal 15, color.to_cterm
    end

    def test_it_correctly_identifies_color_types
      color = Color.new(0)
      assert color.cterm?

      color = Color.new('#333')
      assert color.hexadecimal?
      assert color.gui?

      color = Color.new('NONE')
      assert color.none?
      assert color.cterm?
      assert color.gui?
    end

    def test_it_converts_to_standard_hex
      color = Color.new('afa')
      assert_equal '#aaffaa', color.send(:to_standard_hex)
    end
  end # class TestColor
end # module Vic
