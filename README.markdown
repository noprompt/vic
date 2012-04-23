# Vic

Vic, short for Vim color scheme, gives you the power to create Vim color schemes
with Ruby!

If Vic was a gun these would be the bullets:

  * Flexible usage
  * Handy shortcuts to save you time
  * Automatically coverts hexadecimal colors to cterm (and vice-versa)
  * Dependency free

## Installation

Vic is available as a Ruby gem:

    $ gem install vic

## Usage

Require the file in your script or Gemfile:

```ruby
require 'vic'

gem 'vic', '~> 1.0.0'
```

Creating a new Vim color scheme using Vic is, as my data structures professor
would say, so simple:

```ruby
# Create a new color scheme.
scheme = Vic::ColorScheme.new 'Alligator'

# Add some information to the header of the file.
scheme.add_info Author: 'Joel Holdbrooks <cjholdbrooks@gmail.com>'
scheme.add_info URL: 'https://github.com/noprompt'

# Set the background color (not always necessary, see below).
scheme.background = 'dark'

# Add some highlights (gui hexadecimal colors can be shorthand or standard).
scheme.highlight 'Normal', guibg: '#333', guifg: '#ffffff'

# You can also use the shorthand `hi`.
scheme.hi 'Function', guifg: '#fff', gui: 'bold'

# Or create forced highlights using `hi!` (`highlight!` works too).
scheme.hi! 'rubyClassVariable', gui: 'bold'

# And even regular or forced links.
scheme.link 'Foo', 'Bar'
scheme.link! 'Baz', 'Bar'

# Print the color scheme
puts scheme.render
```

The above code will output:

```viml
" Title: Alligator
" Author: Joel Holdbrooks <cjholdbrooks@gmail.com>
" URL: https://github.com/noprompt

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="Alligator"

hi Normal guifg=#ffffff guibg=#33333
hi Function gui=bold guifg=#ffffff
hi! rubyClassVariable gui=bold
hi link Foo Bar
hi! default link Baz Bar
```

**Note:** You do not have to specify a background unless you want to
explicitly. When rendering your color scheme an will be made to
determine the background setting by checking the "Normal" highlight group's
`guibg` value (if it exists). Otherwise the background will be set to "dark".

Alternatively, you can also write your color scheme in a block which is
evaluated in the context of the `ColorScheme` object.

```ruby
scheme = Vic::ColorScheme.new 'Alligator' do
  add_info Author: 'Joel Holdbrooks <cjholdbrooks@gmail.com>'
  add_info URL: 'https://github.com/noprompt'

  # Forgot to mention you can also drop the "#" from hexadecimal colors too.
  hi! 'Normal', guibg: '333', guifg: 'fff'
  # ...
end
```

## Shortcuts

Let's be honest, building a full fleged color scheme in Vim is a [labor of love](https://github.com/altercation/solarized).
Making sure it looks great in the gui and in the terminal is a lot of hard
work.

Vic attempts to take the edge off and allow the theme developer to focus on what's
really important - building a great theme without a ton of effort.

### Automatic color conversion

When it comes to handcrafting color schemes in Vim, a notable annoyance is
converting hexadecimal colors to their 256 color counterpart. Sure, there are
fabulous tools like [CSApprox](http://www.vim.org/scripts/script.php?script_id=2390)
which will do the dirty work for you, but why should everyone have to install
something extra just to get your theme to work in the terminal?

Consider this example:

```ruby
hi 'Normal', ctermbg: 59, ctermfg: 15, guifg: '#333333', guibg: '#ffffff'
hi 'Function', cterm: 'bold', gui: 'bold'
```

Now, unless you are writing a color scheme generator or just prefer Ruby code to
everything else, using Vic in this manor is almost pointless. Since version
0.0.5 the dual purpose `fg` and `bg` methods are available to highlights, and
`style` since version 1.0.0. So this:

```ruby
hi 'Normal', fg: '#333333', bg: '#ffffff'

# cterm colors (integers between 0 and 255) can be used as well
hi 'Function', fg: 20, style: %w[bold italic]
```

Produces:

```viml
hi Normal ctermbg=59 ctermfg=15 guibg=#333333 guifg=#ffffff
hi Function cterm=bold,italic ctermfg=20 gui=bold,italic guifg=#0000d7
```

Much better, right?

Of course this approach isn't perfect. When using hexadecimal values you may
have to put in just a bit of effort to get it right by adding `ctermfg` or
`ctermbg` settings _after_ the `fg` and `bg` settings.

### Languages

If you've ever written a Vim color scheme, you may have added highlights for a
specific language. To do this you prepend the language name to the highlight
group. In the case of Ruby your color scheme might have highlight groups such as
`rubyFunction`, `rubyBlock`, and so forth.

To clean things up the `Vic::ColorScheme` object provides the method `language`
which takes a language name and a block. Inside the block the language name will
be prepended to any new highlights you create.

```ruby
scheme = Vic::ColorScheme.new 'Amos Moses' do
  hi 'Normal', guifg: '#333333', guibg: '#ffffff'

  language :ruby do
    hi 'Function', gui: 'italic'
    hi 'InstanceVariable', guifg: '#000000', gui: 'bold'
  end
end

scheme.write
```

Will produce the highlights:

```viml
hi Normal guifg=#333333 guibg=#ffffff
hi rubyFunction gui=italic
hi rubyInstanceVariable guibg=#000000 gui=bold
```

## Contributing

Please, please, please feel free to fork, patch, and/or point out any bad code.

## Thanks

I'd like to thank [Micheal Elliot](https://github.com/MicahElliott) for his
[awesome gist](https://gist.github.com/719710) showing how to convert RGB
hexadecimal values to xterm-256 color codes!
