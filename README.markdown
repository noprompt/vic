# Vic

Vic, short for Vim color scheme, gives you the power of Grayskull to create Vim
color schemes with Ruby! Yay!

If Vic was a gun these would be the bullets:

  * Flexible usage and fine-grained control
  * Nifty shortcuts
  * Accurately converts hexadecimal to xterm256-color for cterm
  * Outside of Ruby 1.9.2+ it's dependency freeee with four e's!

## Installation

Vic is available as a Ruby gem:

    $ gem install vic

## Usage

Require the file in your script or Gemfile:

    require 'vic'
    gem 'vic', '~> 0.0.6'

Creating a new Vim color scheme is, hopefully, straight forward:

    # Create a new colorscheme
    scheme = Vic::Colorscheme.new 'Alligator'

    # Add some information to the header of the file
    scheme.info author: 'Joel Holdbrooks', URL: 'https://github.com/noprompt'

    # Set the background color (not necissary, see below)
    scheme.background = 'dark'

    # Add some highlights
    scheme.highlight 'Normal', guibg: '#333333', guifg: '#ffffff'

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

Alternatively, you can also write your color scheme in a block which is
evaluated in the context of the Colorscheme object.

    scheme = Vic::Colorscheme.new 'Alligator' do
      info {
        :author => 'Joel Holdbrooks',
        :URL    => 'https://github.com/noprompt'
      }

      hi 'Normal', guibg: '#333333', guifg: '#ffffff'
      # ...
    end

## Shortcuts

Let's be honest, building a color scheme in Vim is a pain in the ass. Vic
attempts to dry things up and allow the theme developer to focus on what's
really important - building a great theme without going bat shit crazy.

### Automatic color conversion

When it comes to handcrafting color schemes in Vim, a notable annoyance is
converting hexadecimal colors to their 256 color counterpart. Sure, there are
fabulous tools like [CSApprox](http://www.vim.org/scripts/script.php?script_id=2390)
which will do the dirty work for you, but why introduce dependencies or make
Vim do more work?

Consider this example:

      hi 'Normal', ctermbg: 59, ctermfg: 15, guifg: '#333333', guibg: '#ffffff'

Now, unless you are writing a color scheme generator or just prefer Ruby code to
everything else, using Vic in this manor is almost pointless. Since version
0.0.5 the `fg` and `bg` attributes/methods are available to highlights. So
this:

      hi 'Normal', fg: '#333333', bg: '#ffffff'

Produces this:

      hi Normal ctermbg=59 ctermfg=15 guibg=#333333 guifg=#ffffff

Much better, right? Of course it is! But you can be verbose if need be.

### Languages

If you've ever written (or attempted to write) a Vim color scheme, you may have
added highlights for a specific language. To do this you prepend the language
name to the highlight group. In the case of Ruby your color scheme might have
highlight groups such as `rubyFunction`, `rubyBlock`, and so forth.

To clean things up the `Vic::Colorscheme` object provides the method `language`
which takes a block and automatically prepends the language name for you.

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

Cool!

## Contributing

Please, please, please feel free to fork, patch, and/or point out any bad code.

## Thanks

I'd like to thank [Micheal Elliot](https://github.com/MicahElliott) for his
[awesome gist](https://gist.github.com/719710) showing how to convert RGB
hexadecimal values to xterm-256 color codes!
