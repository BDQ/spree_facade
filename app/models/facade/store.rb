require "redis"

module Facade
  class Store
    attr_reader :redis

    def initialize
      @redis = ::Redis.new
    end

    def save(record)
      # save record
      @redis.set key(record), record.hashify.to_json

      # update id index
      name = prefix(record.class)
      @redis.sadd "#{name}-id", record.id

      # update other indexes
      record.index_attributes.each do |attr|
        k = "#{name}-#{attr}-#{record[attr]}"
        puts k
        @redis.set "#{name}-#{attr}-#{record[attr]}", record.id
      end

    end

    def get(klass, id)
      klass.new JSON.parse(@redis.get "#{prefix(klass)}-#{id}")
    end

    def get_all(klass)
      result = []
      name = prefix(klass)
      @redis.smembers("#{name}-id").each do |id|
        data= JSON.parse(@redis.get("#{name}-#{id}"))
        result << klass.new(data)
      end
      result
    end

    def find_by(klass, attr, value)
      key  = prefix(klass)
      id   = @redis.get("#{key}-#{attr}-#{value}")

      if id.nil?
        raise "Can't find #{klass} with '#{attr}' of '#{value}'"
      end

      data = JSON.parse(@redis.get("#{key}-#{id}"))
      klass.new(data)
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
