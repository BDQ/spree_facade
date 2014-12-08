module Facade
  module Field
    class Data < Base
      attribute :value, Hash

      validates_presence_of :value
    end
  end
end
