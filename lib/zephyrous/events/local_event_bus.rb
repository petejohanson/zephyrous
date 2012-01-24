
module Zephyrous
  module Events
    class LocalEventBus
      def initialize(router = LocalEventRouter.new)
        @router = router
      end

      def publish(event)
        @router.find_all(event).each { |h| h.call event }
      end
    end
  end
end
