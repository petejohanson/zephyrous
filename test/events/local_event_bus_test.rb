
require 'teststrap'

context 'given a local event bus' do
  helper(:router) { @router ||= Object.new }
  setup { Zephyrous::Events::LocalEventBus.new(router) }

  context 'given an event with routed handlers' do
    helper(:event) { @event ||= Object.new }
    helper(:handlers) { @handlers ||= [ Object.new, Object.new ] }
    hookup { mock(router).find_all(event) { handlers } }

    asserts("when publishing an event") do
      handlers.each { |h| mock(h).call(event) }

      topic.publish event
    end
  end
end
