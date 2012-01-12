
module Zephyrous
  module Commands
    class Executor

      class CommandHandlerMissing < Exception; end

      def execute(command)
        handler = router.find_handler(command)

        raise CommandHandlerMissing unless handler

        handler.execute(command)
      end

      def router
        Router.new
      end
    end
  end
end
