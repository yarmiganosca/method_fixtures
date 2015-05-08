module MethodFixtures
  class MethodFixture
    attr_reader :receiver, :method_name, :method_parameter_list, :return_value, :raised_error

    def initialize(method_binding, return_value: nil, raised_error: nil)
      @receiver              = method_binding.receiver
      @method_name           = method_binding.method_name
      @method_parameter_list = method_binding.method_parameter_list
      @return_value          = return_value
      @raised_error          = raised_error
    end

    def receiver_type
      if @receiver.respond_to?(:name)
        @receiver.name
      else
        @receiver.class.name
      end
    end
  end
end
