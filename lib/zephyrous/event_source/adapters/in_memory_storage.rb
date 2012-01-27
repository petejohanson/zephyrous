
module Zephyrous
  module EventSource
    module Adapters
      class InMemoryStorage
        def initialize
          @storage = Hash.new { |hash,key| hash[key] = [] }
          @new_events = []
        end

        def process_new_events
          events = Array.new @new_events
          @new_events.clear
          events.each { |e| yield e }
        end

        def find_all(guid)
          @storage[guid]
        end

        def add(*events)
          events.each do |e|
            @storage[e.aggregate_guid] << e
            @new_events << e
          end
        end
      end
    end
  end
end
