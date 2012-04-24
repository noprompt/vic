# Vic

Vic, short for Vim color scheme, gives you the power to create Vim color schemes
with Ruby!

If Vic was a gun these would be the bullets:

  * Flexible usage
  * Handy shortcuts
  * Automatic color conversion
    * hexadecimal to cterm
    * cterm to hexadecimal
    * css style hexadecimal to standard
  * Syntax is close to Vim
  * Dependency free

## Requirements

Vic is compatible with Ruby versions 1.9.2 and higher.

## Installation

Vic is available as a Ruby gem:

    $ gem install vic

Or alternatively:

    $ git clone https://github.com/noprompt/vic.git vic
    $ cd vic
    $ rake install

## Usage

Creating a new Vim color scheme using Vic is so simple.

```ruby
# Require the file in your script.
require 'vic'

# or Gemfile.
gem 'vic', '~> 1.0.0'

# Create a new color scheme with the title "Alligator".
scheme = Vic::ColorScheme.new 'Alligator'

# Add some information to the header of the file.
scheme.add_info Author: 'Joel Holdbrooks'
scheme.add_info URL: 'https://github.com/noprompt'

# Set the background color (not always necessary, see below).
scheme.background = 'dark'

# Add some highlights (gui hexadecimal colors can be shorthand or standard).
scheme.highlight 'Normal', guibg: '#333', guifg: '#ffffff'

# You can also use the shorthand `hi` (as with Vim).
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
" Author: Joel Holdbrooks
" URL: https://github.com/noprompt

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="Alligator"

hi Normal guifg=#ffffff guibg=#333333
hi Function gui=bold guifg=#ffffff
hi! rubyClassVariable gui=bold
hi link Foo Bar
hi! default link Baz Bar
```

Easy right? Yeah, it's a pretty lousy theme but trust me I didn't write this
thing to make "pretty lousy" themes.

Alternatively, you can also write your color scheme in a block like so:

```ruby
Vic::ColorScheme.new 'Alligator' do
  add_info Author: 'Joel Holdbrooks'

  # ...
end

Vic::ColorScheme.new 'Alligator' do |s|
  s.add_info Author: 'Joel Holdbrooks'

  # ...
end
```

## Shortcuts

Let's be honest, building a full fleged color scheme in Vim is a [labor of love](https://github.com/altercation/solarized).
Making sure it looks great in the gui and in the terminal is a lot of hard
work.

Vic attempts to take the edge off and allow the theme developer to focus on what's
really important - building a theme with minimal effort.

### The background

You might have noticed a comment up there about the background setting - you
don't need to worry about it (most of the time). When Vic renders your color
scheme an attempt is made to determine the background setting. Vic checks to see
if you've added a highlight for the group "Normal". If you did and it has a
`guibg` value, it'll figure it out. Otherwise the background will be set to
"dark". If you don't want this sort of behavior, or trust that it works, be sure
to set it manually.

### Automatic color conversion and style (aka why you'd probably wanna use this)

When it comes to handcrafting color schemes in Vim, a notable annoyance is
converting hexadecimal colors to their 256 color counterpart. Sure, there are
fabulous tools like [CSApprox](http://www.vim.org/scripts/script.php?script_id=2390)
which will do the dirty work for you, but why should everyone have to install
something extra just to get your theme to work in the terminal?

Consider this example:

```ruby
# Assuming we're inside a block.
hi 'Normal', ctermbg: 59, ctermfg: 15, guifg: '#333333', guibg: '#ffffff'
hi 'Function', cterm: 'bold', gui: 'bold'
```

It doesn't have to be this way.

Since version 0.0.5 highlights posess the dual purpose `fg` and `bg`, and `style`
since version 1.0.0. These allow you to set both cterm and gui attributes
simultaneously.

`fg` and `bg` will accept any valid cterm or hexadecimal color and convert it
automatically to its counterpart. Cterm colors are **integer** values between
0 and 255. Hexadecimal colors can be in standard or css style formats optionally
with a leading "#".

`style` accepts a value of `"NONE"` or a mix of the following: `bold`, `underline`,
`undercurl`, `reverse`, `inverse`, `italic`, or `standout`.

For example:

```ruby
hi 'Normal', fg: '333', bg: 'fff'
hi 'Function', fg: 20, style: %w[bold italic]
```

Produces:

```viml
hi Normal ctermbg=59 ctermfg=15 guibg=#333333 guifg=#ffffff
hi Function cterm=bold,italic ctermfg=20 gui=bold,italic guifg=#0000d7
```

Much better, right? I hope so.

Of course, this approach isn't perfect. When using hexadecimal values you may
have to put in just a bit of effort to get it right by adding `ctermfg` or
`ctermbg` settings _after_ the `fg` and `bg` settings.

### Languages

If you've ever written a Vim color scheme, you may have added highlights for a
specific language. To do this you prepend the language name to the highlight
group. In the case of Ruby your color scheme might have highlight groups such as
`rubyFunction`, `rubyBlock`, and so forth.

To dry things up the `Vic::ColorScheme` object provides the method `language`
which takes a language name and a block. Inside the block the language name will
be prepended to any new highlights you create.

```ruby
# Assuming we're in a block.
language :ruby do
  hi 'Function', gui: 'italic'
  hi 'InstanceVariable', guifg: '#000000', gui: 'bold'
end
```

Will produce:

```viml
hi rubyFunction gui=italic
hi rubyInstanceVariable gui=bold guibg=#000000
```

See? So simple.

## Contributing

Please feel free to fork, patch, and/or point out any questionable code. If
you'd like to see a featured added, don't hesitate to ask. If you're interested
in submitting a patch, try to follow the guidelines in this [this](http://pastebin.com/Xixb7YNW)
style guide as best as you can and write tests.

## Thanks

I'd like to thank [Micheal Elliot](https://github.com/MicahElliott) for his
[awesome gist](https://gist.github.com/719710) showing how to convert RGB
hexadecimal values to xterm-256 color codes!
