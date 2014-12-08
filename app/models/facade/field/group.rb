module Facade
  module Field
    class Group < Base
      attribute :fields, FieldSet

      def hashify
        self.attributes.merge fields: fields.map(&:hashify),
                              type: self.class.to_s.split('::').last.tableize.singularize
      end

      def render
        if template.present?
          super
        else
          render_children
        end
      end

      def render_children
        self.fields.map(&:render).join "\n"
      end
    end
  end
end
