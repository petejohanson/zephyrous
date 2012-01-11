
class String
  def underscore
    self.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr('-', '_')
        .downcase
  end
end

module Zephyrous
  module EventSource
    module Event
      def event_name_pieces
        self.class.to_s.gsub(/Event$/,'').split('::').map(&:underscore)
      end

      def event_name
        event_name_pieces.join('_')
      end

      def initialize(data = {})
        @data = data
      end

      def method_missing(meth, *args, &block)
        if @data.has_key? meth
          @data[meth]
        else
          super
        end
      end
    end
  end
end
