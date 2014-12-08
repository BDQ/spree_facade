module Facade
  module Field
    class Image < Base
      attribute :src, String
      attribute :alt, String

      validates_presence_of :src
    end
  end
end
