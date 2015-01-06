module Facade
  class Page
    include Virtus.model
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attribute :id, BSON::ObjectId, default: Proc.new { BSON::ObjectId.new.to_s }
    attribute :name, String
    attribute :slug, String
    attribute :layout_id, String

    attribute :fields, FieldSet, default: []

    validates_presence_of :id, :name

    def persisted?
      true
    end

    def valid?
      validate(self.fields)
    end

    def hashify
      self.attributes.merge fields: fields.map(&:hashify), type: type
    end

    def type
      self.class.to_s.split('::').last.tableize.singularize
    end

    def render
      self.fields.map(&:render).join "\n"
    end

    def index_attributes
      [:slug]
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
