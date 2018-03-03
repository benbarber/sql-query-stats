module SqlQueryStats
  # SqlQueryStats Reporter
  class Reporter < ActiveSupport::LogSubscriber
    attr_accessor :stats

    DEFAULTS = {
      total_queries: 0,
      total_duration: 0,
      query_cache_used: 0,
      slowest_query: '',
      slowest_query_duration: 0
    }.freeze

    def self.reset
      stats = Thread.current['sql_query_stats']
      Thread.current['sql_query_stats'] = DEFAULTS.dup
      stats
    end

    def initialize
      super
    end

    def log(key, value)
      Thread.current['sql_query_stats'][key] = value
    end

    def stats
      Thread.current['sql_query_stats'] ||= DEFAULTS.dup
    end

    def sql(event)
      log(:total_queries, stats[:total_queries] + 1)
      log(:total_duration, (stats[:total_duration] + event.duration).round(1))

      check_cache_used(event)
      check_slowest_query(event)
    end

    private

    def check_cache_used(event)
      return unless event.payload[:cached]
      log(:query_cache_used, stats[:query_cache_used] + 1)
    end

    def check_slowest_query(event)
      reportable_queries = %w[SELECT INSERT UPDATE]
      return unless event.duration > stats[:slowest_query_duration]
      return unless event.payload[:sql].start_with?(*reportable_queries)

      report_slowest_query(event)
    end

    def report_slowest_query(event)
      duration = stats[:slowest_query_duration] + event.duration

      log(:slowest_query, Sanitizer.sanitize(event.payload[:sql]))
      log(:slowest_query_duration, duration.round(1))
    end
  end
end
