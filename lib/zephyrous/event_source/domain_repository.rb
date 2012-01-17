
module Zephyrous
  module EventSource
    class DomainRepository

      attr_reader :unit_of_work

      def initialize(unit_of_work)
        @unit_of_work = unit_of_work
      end

      def find(klass, guid)
        # TODO: Check the identity map too
        track unit_of_work.find(klass, guid)
      end

      def add(aggregate_root)
        track aggregate_root
      end

      private
      
      def track(aggregate_root)
        unit_of_work.track(aggregate_root)
      end
    end
  end
end
