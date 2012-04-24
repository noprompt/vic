require File.expand_path('../test_helper', __FILE__)

module Vic
  class TestLink < MiniTest::Unit::TestCase
    def test_it_forces
      link = Vic::Link.new('rubyClassVariable', 'rubyInstanceVariable')
      assert link.force!
      assert link.force?
    end
  end # class TestLink
end # module Vic
