module SqlQueryStats
  # SqlQueryStats Controler Runtime
  module ControllerRuntime
    extend ActiveSupport::Concern

    protected

    def process_action(action, *args)
      Reporter.reset
      super
    end

    def append_info_to_payload(payload)
      super
      payload[:sql_query_stats] = Reporter.reset if ActiveRecord::Base.connected?
    end

    # Add QueryStats to the Rails Process Action log
    module ClassMethods
      def log_process_action(payload)
        messages = super
        exclusions = %i[total_duration]
        stats = payload[:sql_query_stats].with_indifferent_access

        stats.except(*exclusions).each do |stat, value|
          messages << formatted_message(stat, value)
        end

        messages
      end

      private

      def formatted_message(stat, value)
        value = "#{value}ms" if stat.end_with? 'duration'
        "#{stat.to_s.camelize}: #{value}"
      end
    end
  end
end
