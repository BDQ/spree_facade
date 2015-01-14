 module Spree
  class RenderController < StoreController
    def show
      @resource = store.find_by(Facade::Resource, :slug, request.path)

      render text: @resource.render, layout: true
    end

    private

    def store
      @store = Facade::Store.new() #TODO: pass config
    end
  end
end
