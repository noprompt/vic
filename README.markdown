# Vic

Vic lets you create Vim colorschemes in Ruby.

## About

This library is (obviously) in it's early stages of development. It's missing
several key features, but at the moment gets the job done.

## Installation

Vic is available as a Rubygem:

    $ gem install vic

## Usage

Require the file in your script or Gemfile:

    require 'vic'
    gem 'vic', '~> 0.0.2'

Creating a new Vim colorscheme is, hopefully straight forward:

    # Create a new colorscheme
    scheme = Vic::Colorscheme.new 'Alligator'

    # Add some information to the header of the file
    scheme.info author: 'Joel Holdbrooks', URL: 'https://github.com/noprompt'

    # Set the background color (not necissary, see below)
    scheme.background = 'dark'

    # Add some highlights
    scheme.highlight 'Normal', guibg: '#33333', guifg: '#ffffff'

    # You can also use the shorthand `hi`
    scheme.hi 'Function', guifg: '#ffffff', gui: 'bold'

    # Print the colorscheme
    puts scheme.write

The above code will output:

    " Vim color file
    " Author: Joel Holdbrooks
    " URL: https://github.com/noprompt
    set background=dark
    hi clear

    if exists("syntax_on")
      syntax reset
    endif

    let g:colors_name="Alligator"

    hi Normal guifg=#ffffff guibg=#33333
    hi Function gui=bold guifg=#ffffff

**Note:** You do not have to specify a background unless you want to
explicitly. Vic will attempt to determine the background setting from the
`Normal` highlight group's `guibg` value (if it exists). Otherwise Vic
automatically sets the background value to `dark`.

Alternatively, you can also write your colorscheme in a block which is evaluated
in the context of the Colorscheme object.

    scheme = Vic::Colorscheme.new 'Alligator' do
      info {
        :author => 'Joel Holdbrooks',
        :URL    => 'https://github.com/noprompt'
      }

      hi 'Normal', guibg: '#333333', guifg: '#ffffff'
      # ...
    end

If you've ever written (or attempted to write) a Vim colorscheme, you may have
added highlights for a specify language. To do this you prepend the language
name to the highlight group. In the case of Ruby your colorscheme might have
highlight groups such as `rubyFunction`, `rubyBlock`, and so forth.

To clean things up the `Vic::Colorscheme` object provides the method language
which takes a block and automatically prepends the name for you.

    scheme = Vic::Colorscheme.new 'Amos Moses' do
      hi 'Normal', guifg: '#333333', guibg: '#ffffff'

      language :ruby do
        hi 'Function', gui: 'italic'
        hi 'InstanceVariable', guifg: '#000000', gui: 'bold'
      end
    end

    scheme.write

Which will produce the highlights:

    hi Normal guifg=#333333 guibg=#ffffff
    hi rubyFunction gui=italic
    hi rubyInstanceVariable guibg=#000000 gui=bold
