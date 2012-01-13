task :default => [:test]

task :test do
  `find ./test -name \*.rb`.split("\n").map {|testfile| ruby testfile}
end
