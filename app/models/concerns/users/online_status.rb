module Concerns
  module Users
    module OnlineStatus
      extend ActiveSupport::Concern

      ONLINE_KEY = 'online_users'

      def online?
        $redis.hget(ONLINE_KEY, self.id).to_i > 0
      end

      def seen
        $redis.hset(ONLINE_KEY, self.id, 1)
      end

      def left
        user_connections = $redis.hincrby(ONLINE_KEY, self.id, -1)
        user_connections
      end

      module ClassMethods
        def online_count
          $redis.hgetall(ONLINE_KEY).map{|k,v| v.to_i > 0 ? 1 : 0}.inject(0,:+)
        end
      end

    end
  end
end