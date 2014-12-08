module Facade
  class Layout
    include Virtus.model
    include ActiveModel::Validations

    attribute :id, BSON::ObjectId, default: BSON::ObjectId.new.to_s
    attribute :name, String

    attribute :fields, FieldSet, default: []

    validates_presence_of :id, :name

    def repository
      @repository ||= Facade::Redis.new
    end

    def repository=(instance)
      @repository = instance
    end

      def hashify
        self.attributes.merge type: self.class.to_s.split('::').last.tableize.singularize
      end

    def build_page
      page = Page.new

      fields.each do |field|
        page.fields << field.clone
      end

      page
    end
  end
end
