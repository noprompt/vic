require 'test/unit'
require File.expand_path('../../lib/vic.rb', __FILE__)

class VersionTest < Test::Unit::TestCase
  def test_version
    assert Vic::VERSION
  end
end
