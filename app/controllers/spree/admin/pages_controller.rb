module Spree
  module Admin
    class PagesController < Spree::Admin::BaseController
      def index
        @pages = store.get_all(Facade::Page)
      end

      def edit
        @page = store.get(Facade::Page, params[:id])
      end

      def update
        @page = Facade::Page.new(params[:facade_page])
        byebug
        store.save(@page)

        redirect_to admin_pages_path, notice: 'Page has been successfully updated'
      end

      private

      def store
        @store = Facade::Store.new() #TODO: pass config
      end
    end
  end
end
