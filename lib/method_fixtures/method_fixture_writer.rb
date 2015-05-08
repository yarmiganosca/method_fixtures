module MethodFixtures
  class MethodFixtureWriter
    def initialize(fixture_repository)
      @fixture_repository = fixture_repository
    end

    def write_fixture(method_fixture)
      filepath = File.join(@fixture_repository.fixture_directory,
                           method_fixture.receiver_type,
                           method_fixture.method_name,
                           Time.now.to_i.to_s)

      @fixture_repository.mkdir_p(File.dirname(filepath))

      File.write(filepath, Marshal.dump(method_fixture))
    end
  end
end
