
module Zephyrous
  module EventSource
    module Entity
      def self.from_events(events)
        agg = self.new
        events.each { |ev| agg.apply ev }

        agg
      end

      def apply(ev)

      end
    end
  end
end
