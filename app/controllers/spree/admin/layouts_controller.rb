module Spree
  module Admin
    class LayoutsController < Spree::Admin::BaseController
      def index
        @layouts = store.get_all(Facade::Layout)
      end

      def edit
        @layout = store.get(Facade::Layout, params[:id])
      end

      def update
        byebug
        1
      end

      private

      def store
        @store = Facade::Store.new() #TODO: pass config
      end
    end
  end
end
