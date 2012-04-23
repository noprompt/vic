$:.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'vic'

module Vic
  class TestColor < MiniTest::Unit::TestCase
    def test_it_converts_a_color_to_gui
      color = Color.new(0)
      assert_equal '#000000', color.to_gui

      color = Color.new(255)
      assert_equal '#eeeeee', color.to_gui
    end

    def test_it_converts_a_color_to_cterm
      color = Color.new('#000000')
      assert_equal 0, color.to_cterm

      color = Color.new('#eeeeee')
      assert_equal 255, color.to_cterm
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

    def test_it_raises_an_error
      color = Color.new('a')
      assert_raises(Vic::Color::ColorError) { color.to_gui }
      assert_raises(Vic::Color::ColorError) { color.to_cterm }

      color = Color.new(-2)
      assert_raises(Vic::Color::ColorError) { color.to_cterm }
      assert_raises(Vic::Color::ColorError) { color.to_gui }
    end
  end # class TestColor
end # module Vic
