require 'method_fixtures/method_binding'
require 'method_fixtures/method_fixture'
require 'method_fixtures/method_fixture_writer'

module MethodFixtures
  class FixtureRepository
    attr_reader :fixture_directory

    def initialize(fixture_directory)
      @fixture_directory = fixture_directory
    end

    def capture
      method_binding = MethodBinding.new(depth: 2)

      begin
        return_value = yield
      rescue => raised_error
      end

      if defined?(return_value) && return_value
        self << MethodFixture.new(method_binding, return_value: return_value)

        return return_value
      end
      
      if defined?(raised_error) && raised_error
        self << MethodFixture.new(method_binding, raised_error: raised_error)

        raise raised_error
      end
    end

    def fixture_count
      fixtures.size
    end

    def fixtures
      Dir["#{fixture_directory}/**/*"].reject(&File.method(:directory?))
    end

    def <<(method_fixture)
      MethodFixtureWriter.new(self).write_fixture(method_fixture)
    end

    def fixture_from_file(filepath)
      Marshal.load(File.read(filepath))
    end

    def mkdir_p(directory)
      `mkdir -p #{directory}`
    end

    def reset!
      return unless File.exists?(fixture_directory)

      `rm -rf #{fixture_directory}/*`
    end
  end
end
