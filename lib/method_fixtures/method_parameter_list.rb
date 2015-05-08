require 'method_fixtures/method_parameter'

module MethodFixtures
  class MethodParameterList
    def initialize(method_parameters, binding)
      @parameters = method_parameters.map do |parameter_type, parameter_name|
        MethodParameter.new(name:  parameter_name,
                            type:  parameter_type,
                            value: binding.eval(parameter_name.to_s))
      end
    end

    def positional_parameter_values
      parameters_of_type(:req, :opt).map(&:value)
    end

    def splat_parameter_value
      splat_parameter = parameters_of_type(:rest).first || null_splat_parameter

      splat_parameter.value
    end

    def keyword_parameters_hash
      keyword_parameters = parameters_of_type(:key, :keyreq)
        .map { |parameter| [parameter.name, parameter.value] }

      Hash[keyword_parameters]
    end

    def block_parameter_value
      block_parameter = parameters_of_type(:blk).first || null_block_parameter

      block_parameter.value
    end

    private def parameters_of_type(*parameter_types)
              @parameters.select do |parameter|
                parameter_types.include?(parameter.type)
              end
            end

    private def null_splat_parameter
              MethodParameter.new(name:  '',
                                  type:  :rest,
                                  value: [])
            end

    private def null_block_parameter
              MethodParameter.new(name:  '',
                                  type:  :blk,
                                  value: Proc.new {})
            end
  end
end
