$:.unshift File.expand_path('../../lib', __FILE__)
require 'vic'
require 'test/unit'

class VersionTest < Test::Unit::TestCase
  def test_version
    assert_equal Vic::VERSION, '0.0.4'
  end
end
