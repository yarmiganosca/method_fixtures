require_relative 'spec_helper'

describe 'capturing a raised error' do
  class Foo
    def quux
      TestFixtures.capture do
        1 / 0
      end
    end

    def quux_safely
      begin
        Foo.new.quux
      rescue ZeroDivisionError
      end
    end
  end

  after { TestFixtures.reset! }

  describe 'the instrumented method' do
    it 'creates a method fixture' do
      TestFixtures.fixture_count.must_equal(0)

      Foo.new.quux_safely

      TestFixtures.fixture_count.must_equal(1)
    end

    it 'reraises the raised error' do
      Proc.new do
        Foo.new.quux
      end.must_raise ZeroDivisionError
    end
  end

  describe 'the captured fixture' do
    before { Foo.new.quux_safely }

    let(:filepath) { TestFixtures.fixtures.last }
    let(:fixture)  { TestFixtures.fixture_from_file(filepath) }
    let(:invoker)  { MethodFixtures::MethodInvoker.new(fixture) }

    it 'when invoked, raises the correct type of error' do
      fixture.raised_error.must_be_instance_of ZeroDivisionError

      proc { invoker.invoke_method }.must_raise fixture.raised_error.class
    end
  end
end
