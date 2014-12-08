module Spree
  module Admin
    class LayoutsController < Spree::Admin::BaseController
      def index
        render text: 'abc123'
      end
    end
  end
end
