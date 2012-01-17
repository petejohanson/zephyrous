
require 'teststrap'

context 'given an executor' do
  helper(:router) { @router ||= Object.new }
  setup { Zephyrous::Commands::Executor.new(router) }

  asserts("executing a command with no handler") do
    command = Object.new
    mock(topic.router).find_handler(command) { nil }

    topic.execute(command)
  end.raises(Zephyrous::Commands::Executor::CommandHandlerMissing)

  context 'when executing a command with handler' do
    helper(:command) { @command ||= Object.new }
    helper(:handler) { @handler ||= Object.new }
    helper(:response) { @response ||= Object.new }
    hookup do
      stub(topic.router).find_handler(command) { handler }
    end

    asserts("invokes the handler and returns the value") do
      mock(handler).execute(command) { response }

      topic.execute(command)
    end
  end
end
