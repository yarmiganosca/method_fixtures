require_relative 'spec_helper'

describe 'capturing a return value' do
  class Foo
    def bar(baz)
      TestFixtures.capture do
        baz
      end
    end
  end

  after { TestFixtures.reset! }

  describe 'the instrumented method' do
    it 'creates a method fixture' do
      TestFixtures.fixture_count.must_equal(0)

      Foo.new.bar(42)

      TestFixtures.fixture_count.must_equal(1)
    end

    it 'returns the return value of the method' do
      Foo.new.bar(42).must_equal(42)
    end
  end

  describe 'the captured fixture' do
    before { Foo.new.bar(42) }

    let(:filepath) { TestFixtures.fixtures.last }
    let(:fixture)  { TestFixtures.fixture_from_file(filepath) }
    let(:invoker)  { MethodFixtures::MethodInvoker.new(fixture) }

    it 'when invoked, has the correct return value' do
      fixture.return_value.must_equal(42)

      invoker.invoke_method.must_equal(fixture.return_value)
    end

    describe 'after a visible change' do
      before do
        receiver = fixture.receiver

        def receiver.bar(baz)
          baz + 1
        end
      end

      it "won't match the fixture's return value" do
        fixture.return_value.must_equal(42)

        invoker.invoke_method.must_equal(fixture.return_value + 1)
      end
    end
  end
end
