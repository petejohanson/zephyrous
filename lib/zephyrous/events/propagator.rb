
module Zephyrous
  module Events
    class Propagator

      def iterate
        @storage.process_new_events { |events| events.each { |e| @bus.publish e } }
      end

      def initialize(storage, bus)
        @storage = storage
        @bus = bus
      end
    end
  end
end
