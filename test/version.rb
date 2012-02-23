$:.unshift File.expand_path('../../lib', __FILE__)
require 'vic'
require 'test/unit'

class VersionTest < Test::Unit::TestCase
  def test_version
    assert_equal Vic::VERSION, '0.0.6'
  end

  def test_gemspec_version_matches_vic_version
    vic_gemspec_version = File.read('vic.gemspec').match(/(\d\.\d\.\d)/)[0]
    assert_equal Vic::VERSION, vic_gemspec_version
  end

  def test_readme_version_matches_vic_version
    vic_gemspec_version = File.read('README.markdown').match(/(\d\.\d\.\d)/)[0]
    assert_equal Vic::VERSION, vic_gemspec_version
  end
end
