
module Zephyrous
  module Commands
    class Executor

      class CommandHandlerMissing < Exception; end

      attr_reader :router

      def initialize(router)
        @router = router
      end

      def execute(command)
        handler = router.find_handler(command)

        raise CommandHandlerMissing unless handler

        handler.execute(command)
      end
    end
  end
end
