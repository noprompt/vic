task :test do
  # It's nice to clear the screen first. Especially when you are running tests
  # over and over again...
  sh 'clear'
  # Find all the ruby files in the test folder and run each of them.
  Dir.glob("./test/*.rb").reject { |f| f.match(/helper/) }.map { |f| ruby f }
end

task :install do
  sh 'gem build vic.gemspec'
  sh 'gem install vic-1.0.0.gem'
  sh 'rm vic-1.0.0.gem'
end
