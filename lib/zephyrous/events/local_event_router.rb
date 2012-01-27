
module Zephyrous
  module Events
    class LocalEventRouter
      def add_namespace(ns)
        namespaces << ns
      end

      def find_all(event)
        (namespaces + [Kernel]).map do |ns|
          ns.constants.map { |c| ns.const_get c }.select { |c| c.handles? event.class }
        end.flatten
      end

      def namespaces
        @namespaces ||= Set.new
      end
    end
  end
end
