module Facade
  module Field
    class Base
      include Virtus.model
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      attribute :id, BSON::ObjectId, default: Proc.new { BSON::ObjectId.new.to_s }
      attribute :name, String
      attribute :required, Boolean, default: false
      attribute :language, String, default: 'en-US'

      attribute :engine, Symbol, default: :erubis
      attribute :template, String, default: :default_template

      def persisted?
        true
      end

      def find(name)
        if self.name == name
          return self
        elsif self.is_a? Field::Group
          self.fields.detect do |field|
            field.find(name)
          end
        end
      end

      def type
        self.class.to_s.split('::').last.tableize.singularize
      end

      def hashify
        self.attributes.merge type: type
      end

      def render
        # TODO: Extract this to a class, that can be replaced via the :engine attribute
        erb = Erubis::Eruby.new(template)
        erb.result(field: self)
      end

      private

      def default_template
        file = self.class.to_s.split('::').last.downcase
        path = Pathname.new(Dir.pwd).join('templates/', "#{file}.html.erb")

        path.exist? ? path.read : ''
      end
    end
  end
end
