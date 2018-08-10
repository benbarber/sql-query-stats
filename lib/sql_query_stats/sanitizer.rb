module SqlQueryStats
  # SqlQueryStats Sanitizer
  class Sanitizer
    def self.sanitize(sql_query_string)
      filters = Rails.application.config.filter_parameters
      sql = sql_query_string.dup
      sql = filter_params(filters, sql)
      filter_values(sql)
    end

    def self.filter_params(filters, sql)
      filters.each do |filter|
        sql.gsub!(/`#{filter}` = '[^']+'/, "#{filter} = '[FILTERED]'")
      end

      sql
    end

    def self.filter_values(sql)
      sql.gsub!(/(?:VALUES(?:\s?)\()(.*)(?:\)+)/, 'VALUES(?)')
    end
  end
end
