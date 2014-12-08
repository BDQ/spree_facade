require "redis"

module Facade
  class Redis
    def initialize
      @redis = ::Redis.new
    end

    def save(field)
      #save record
      @redis.set key(field), field.hashify.to_json

      #maintain list of records
      @redis.lpush prefix(field.class), field.id
    end

    def read(id)
      @redis.get id
    end

    private

    def key(field)
      "#{prefix(field.class)}-#{field.id}"
    end

    def prefix(klass)
      klass.to_s.tableize.singularize.gsub('/','_')
    end
  end
end
