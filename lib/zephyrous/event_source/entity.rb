
module Zephyrous
  module EventSource
    module Entity

      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def from_events(events)
          self.new.tap { |agg| events.each { |ev| agg.send(:apply_event, ev) } }
        end

        def create_from_event(event)
          self.new.tap { |agg| agg.send(:add_event, event) }
        end
      end

      def new_events
        @new_events ||= Array.new
      end

      private

      def add_event(event)
        apply_event(event)
        new_events << event
      end

      def apply_event(event)
        handler = find_handler(event)

        self.send(handler, event) if handler
      end
      
      def find_handler(event)
        pieces = event.event_name_pieces

        # TODO: Ugh. This sucks. Basically, given an array of:
        #
        # [ "shipping", "order", "created" ]
        #
        # we want to check for the following methods:
        #
        # on_created
        # on_order_created
        # on_shipping_order_created
        #
        # This little disgusting mess does the job, but is ugly as sin.
        pieces.each_index
              .reverse_each
              .map { |i| pieces[i..pieces.count] }
              .map { |p| ["on", *p].join("_").to_sym }
              .select { |sym| self.respond_to? sym }
              .first
      end
    end
  end
end
