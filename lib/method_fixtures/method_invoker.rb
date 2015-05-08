require 'forwardable'

module MethodFixtures
  class MethodInvoker
    extend Forwardable

    def_delegators :@method_fixture, :receiver, :method_name, :method_parameter_list

    def initialize(method_fixture)
      @method_fixture = method_fixture
    end

    def invoke_method
      if method_takes_keyword_arguments?
        invoke_method_with_keyword_arguments
      else
        invoke_method_without_keyword_arguments
      end
    end

    private def method_takes_keyword_arguments?
              !keyword_arguments.empty?
            end

    private def invoke_method_with_keyword_arguments
              receiver.send(method_name,
                            *positional_arguments,
                            *splat_argument,
                            **keyword_arguments,
                            &block_argument)
            end

    private def invoke_method_without_keyword_arguments
              receiver.send(method_name,
                            *positional_arguments,
                            *splat_argument,
                            &block_argument)
            end

    private def positional_arguments
              method_parameter_list.positional_parameter_values
            end

    private def splat_argument
              method_parameter_list.splat_parameter_value
            end

    private def keyword_arguments
              method_parameter_list.keyword_parameters_hash
            end

    private def block_argument
              method_parameter_list.block_parameter_value
            end
  end
end
