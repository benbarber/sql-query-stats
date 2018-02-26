module SqlQueryStats
  # QueryStats Initializer
  class Initializer < Rails::Railtie
    initializer 'sql_query_stats.initialize' do
      # Attach to the reporter ActiveRecord Events
      SqlQueryStats::Reporter.attach_to :active_record

      # Load the controller runtime
      ActiveSupport.on_load(:action_controller) do
        include SqlQueryStats::ControllerRuntime
      end
    end
  end
end
