module Facade
  class Layout
    include Virtus.model
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attribute :id, BSON::ObjectId, default: Proc.new { BSON::ObjectId.new.to_s }
    attribute :name, String

    attribute :fields, FieldSet, default: []

    validates_presence_of :id, :name

    def persisted?
      true
    end

    def repository
      @repository ||= Facade::Redis.new
    end

    def repository=(instance)
      @repository = instance
    end

    def hashify
      self.attributes.merge fields: fields.map(&:hashify),
                            type: self.class.to_s.split('::').last.tableize.singularize
    end

    def build_page
      page = Page.new
      page.name = "New #{self.name}"
      page.layout_id = self.id

      fields.each do |field|
        page.fields << field.clone
      end

      page
    end

    def index_attributes
      []
    end
  end
end
