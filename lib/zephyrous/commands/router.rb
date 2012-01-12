
module Zephyrous
  module Commands
    class Router
      def add_namespace(ns)
        namespaces << ns
      end

      def find_handler(command)
        handler_name = (command.class.to_s.split('::').last + 'Handler').to_sym
        namespace = (namespaces + [Object]).select { |ns| ns.constants.include? handler_name }.first

        return nil unless namespace

        [*namespace.to_s.split('::'), handler_name].inject(Kernel) { |scope, name| scope.const_get name }.new
      end

      def namespaces
        @namespaces ||= Set.new
      end
    end
  end
end
