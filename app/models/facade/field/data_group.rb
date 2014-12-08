module Facade
  module Field
    class DataGroup < Group
      attribute :fields, FieldSet

      validates_each :fields do |record, attr, value|
        value.each do |v|
          record.errors.add attr, ' must all be of type Field::Date' unless v.is_a? Field::Date
          record.errors.add attr, v.errors.full_messages if v.invalid?
        end
      end
    end
  end
end
