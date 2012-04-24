require File.expand_path('../test_helper', __FILE__)

module Vic
  class TestColorSchemeWriter < MiniTest::Unit::TestCase
    def test_it_writes_a_colorscheme
      colorscheme = Vic::ColorScheme.new 'Alabama'
      colorscheme.info = { Author: 'Joel Holdbrooks <cjholdbrooks@gmail.com>', URI: 'http://github.com/noprompt' }
      colorscheme.hi! :Normal, bg: 'fff', fg: '000'
      colorscheme.hi! :Foo, style: %w(bold italic)
      colorscheme.link! :Bar, :Baz, :Quux

      writer = Vic::ColorSchemeWriter.new(colorscheme)

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

      assert_equal result, writer.write
    end

  end # TestColorSchemeWriter
end # module Vic

