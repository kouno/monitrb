module MonitRB
  module Exceptions
    class UnexpectedConfigurationVariable < StandardError
      def initialize(values)
        super("Unexpected config variable: #{find_unknown_keys(values).join(', ')}")
      end

      def find_unknown_keys(values)
        config = MonitRB::Config.new
        values.keys.select do |key|
          !config.respond_to?(key)
        end
      end
    end
  end
end
