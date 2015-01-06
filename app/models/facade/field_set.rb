module Facade
  class FieldSet < Virtus::Attribute
    def coerce(fields)
      return if fields.nil?

      fields.map do |obj|
        if obj.is_a? Field::Base
          obj
        elsif klass = obj[:type] || obj['type']
          begin
            klass = klass.classify
            klass = 'Data' if klass == 'Datum'

            "Facade::Field::#{klass}".constantize.new(obj)
          rescue Exception => e
            byebug
            raise
            #raise ArgumentError, "Problem constantizing :type for: #{klass}"
          end
        else
          raise ArgumentError, "Serialized Field must contain :type attribute: #{obj}"
        end
      end
    end
  end
end
