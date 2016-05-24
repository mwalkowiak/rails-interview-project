
  # Note: This is my own class for throttling. I know there is a bunch of ready gems like rack-attack/grape-attack,
  # but they didn't support nested rules like this one, so I decided not to hack into them and create my own solution.
  # There might be some minor improvements, but it should be enough for the sake of this task
  class ApiThrottle

    class << self

      def incr(key, time_to_expire)
        val = $redis_client.incr(key)
        $redis_client.expire(key, time_to_expire) if val == 1
        val
      end

      def threshold?(key, rules = [])

        return false if rules.empty?

        if rules.is_a?(Hash)
          rule = rules
        else
          rule = rules.first
        end

        lookup_key = "#{key}#{rule['req_count']}#{rule['duration'].to_i}"
        incremented_value = self.incr(lookup_key, rule['duration'].to_i)

        if incremented_value >= (rule['req_count'] + 1) && rules.is_a?(Hash)
          return true
        elsif incremented_value < (rule['req_count'] + 1)
          return false
        else
          # Support for additional rule
          last_rule = rules[1]
          self.threshold?(key, last_rule)
        end
      end
    end

  end

