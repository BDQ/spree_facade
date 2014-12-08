module Facade
  module Field
    class ImageGroup < Group
      attribute :fields, FieldSet

      validates_each :fields do |record, attr, value|
        value.each do |v|
          record.errors.add attr, ' must all be of type Field::Image' unless v.is_a? Field::Image
          record.errors.add attr, v.errors.full_messages if v.invalid?
        end
      end
    end
  end
end
