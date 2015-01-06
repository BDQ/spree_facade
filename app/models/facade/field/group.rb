module Facade
  module Field
    class Group < Base
      attribute :fields, FieldSet, default: []
      attribute :min_children, Integer, default: 0
      attribute :max_children, Integer

      def hashify
        byebug if fields.nil?
        self.attributes.merge fields: fields.map(&:hashify), type: type
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
