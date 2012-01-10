module Zephyrous
  module EventSource
    class UnitOfWork
      def find(klass, guid)
      end

      def track(aggregate_root)
        tracked << aggregate_root
      end

      def commit
        tracked.each { |ar| storage.add ar.new_events }
      end

      def storage
        @storage ||= EventStorage.new
      end

      private

      def tracked
        @tracked ||= Set.new
      end
    end
  end
end
