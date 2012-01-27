
module Zephyrous
  module Events
    module Handler

      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def handles?(klass)
          handlers.has_key? klass
        end

        def on(klass, &block)
          handlers[klass] << block
        end

        def handle(event)
          handlers[event.class].each { |h| h.call(event) }
        end

        def handlers
          @handlers ||= Hash.new { |hash,key| hash[key] = [] }
        end
      end
    end
  end
end
