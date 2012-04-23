Gem::Specification.new do |s|
  s.name        = 'vic'
  s.version     = '1.0.0'
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = 'Create Vim colorschemes'
  s.description = 'Create Vim colorschemes with Ruby'
  s.authors     = ['Joel Holdbrooks']
  s.email       = 'cjholdbrooks@gmail.com'
  s.homepage    = 'https://github.com/noprompt/vic'
  s.files       = ['lib/vic.rb',
                   'lib/vic/color.rb',
                   'lib/vic/color_scheme.rb',
                   'lib/vic/color_scheme_writer.rb',
                   'lib/vic/convert.rb',
                   'lib/vic/highlight.rb',
                   'lib/vic/link.rb',
                   'lib/vic/xterm_color.rb']
end
