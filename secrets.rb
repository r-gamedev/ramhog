
module Lemtzas
  module Common
    # Base for configuration wrappers. Can be used on its own.
    class RedisBase
      def initialize(redis = nil)
        @redis = redis || Redis.new
        raise 'Bad redis' unless @redis.respond_to? :get
        raise 'Bad redis' unless @redis.respond_to? :set
      end

      def [](ind)
        @redis.get ind
      end

      def []=(ind, val)
        @redis.set ind, val
      end
    end # class RedisBase

    # A base class for retrieving and verifying secrets
    # To use, inherit and do:
    # KEYS = %w(irc_username irc_password).freeze
    # attr_reader(*KEYS)
    class SecretsBase < RedisBase
      def initialize(redis = nil)
        super(redis)
        refresh
      end

      def self.attr_reader(*keys)
        @secrets ||= []
        @secrets.concat keys
        super(*keys)
      end

      def self.secrets
        @secrets
      end

      def secrets
        self.class.secrets
      end

      # refresh the secrets.
      def refresh
        secrets.each do |key|
          instance_variable_set "@#{key}", self[key]
        end

        bad_keys =
          secrets.map { |key| !send(key) ? key : nil }
                 .select { |v| v }

        abort "Aborting. Missing secrets: #{bad_keys}" if bad_keys.any?
      end
    end # class SecretsBase
  end # module Common
end # module Lemtzas

module Lemtzas
  module Gdevspam
    # Secrets for Gdevspam
    class Secrets < Lemtzas::Common::SecretsBase
      KEYS = %w(irc_username irc_password).freeze
      attr_reader(*KEYS)
    end
  end # module Common
end # module Lemtzas
