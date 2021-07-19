require 'test_helper'

module SqlQueryStats
  class SanitizerTest < ActiveSupport::TestCase
    test '.filter_params filters successfully' do
      original = "SELECT `users`.* FROM `users` WHERE `users`.`name` = 'test' AND `users`.`password` = 'password'"
      expected = "SELECT `users`.* FROM `users` WHERE `users`.`name` = 'test' AND `users`.`password` = '[FILTERED]'"

      result = SqlQueryStats::Sanitizer.filter_params([:password], original)
      assert_equal(expected, result)
    end

    test '.filter_params makes no change' do
      original = "SELECT `users`.* FROM `users` WHERE `users`.`name` = 'test'"

      result = SqlQueryStats::Sanitizer.filter_params([:password], original)
      assert_equal(original, result)
    end

    test '.filter_values filters successfully' do
      original = "INSERT INTO `users` (`id`, `name`, `password`) VALUES (1, 'name', 'password')"
      expected = "INSERT INTO `users` (`id`, `name`, `password`) VALUES (?)"

      result = SqlQueryStats::Sanitizer.filter_values(original)
      assert_equal(expected, result)
    end

    test '.filter_values makes no change' do
      original = "SELECT `users`.* FROM `users` WHERE `users`.`name` = 'test'"

      result = SqlQueryStats::Sanitizer.filter_values(original)
      assert_equal(original, result)
    end
  end
end
