module SpreeFacade
  class Engine < Rails::Engine
    require 'spree/core'
    require 'virtus'
    require 'inflecto'
    require 'ejs'

    isolate_namespace Spree
    engine_name 'spree_facade'

    #rake_tasks do
      #%w{setup}.each { |r| load File.join([File.dirname(__FILE__) , "../tasks/#{r}.rake"]) }
    #end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
