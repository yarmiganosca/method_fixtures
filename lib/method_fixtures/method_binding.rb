require 'binding_of_caller'
require 'method_fixtures/method_parameter_list'

module MethodFixtures
  class MethodBinding
    attr_reader :method_name

    def initialize(depth: 1)
      @binding     = binding.of_caller(depth)
      @method_name = caller_locations[depth].base_label
    end

    def method_object
      receiver.method(method_name)
    end

    def method_parameter_list
      MethodParameterList.new(method_object.parameters, @binding)
    end

    def receiver
      @receiver ||= @binding.eval('self')
    end
  end
end
