module Facade
  class Page
    include Virtus.model
    include ActiveModel::Validations

    attribute :id, BSON::ObjectId, default: BSON::ObjectId.new.to_s
    attribute :name, String
    attribute :slug, String

    attribute :fields, FieldSet, default: []

    validates_presence_of :id, :name

    def valid?
      validate(self.fields)
    end

    private

    def validate(fields)
      if fields.is_a? Array
        fields.all? do |field|
          validate(field)
        end
      else
        fields.required ? fields.valid? : true
      end
    end
  end
end
