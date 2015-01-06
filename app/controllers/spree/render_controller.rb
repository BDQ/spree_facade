 module Spree
  class RenderController < StoreController
    def show
      @page = store.find_by(Facade::Page, :slug, request.path)

      render text: @page.render, layout: true
    end

    private

    def store
      @store = Facade::Store.new() #TODO: pass config
    end
  end
end
