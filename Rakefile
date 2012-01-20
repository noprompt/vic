task :default => [:test]

task :test do
  # It's nice to clear the screen first. Especially when you are running tests
  # over and over again...
  system('clear')
  # Find all the ruby files in the test folder and run each of them.
  `find ./test -name \*.rb`.split("\n").map {|testfile| ruby testfile}
end
