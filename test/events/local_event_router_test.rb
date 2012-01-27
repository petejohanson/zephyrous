
require 'teststrap'


module Coffee
  class BrewedEvent
  end

  class SpilledEvent
  end

  class OrderPlacedEvent
  end
end

module CoffeeViews
  class CounterView
    include Zephyrous::Events::Handler

    on Coffee::BrewedEvent do |e|
    end
  end

  class BaristaView
    include Zephyrous::Events::Handler
    
    on Coffee::OrderPlacedEvent do |e|
    end
  end
end

context 'given a router' do
  setup { Zephyrous::Events::LocalEventRouter.new }

  context 'with an added namespace' do
    hookup { topic.add_namespace CoffeeViews }

    context 'when find_all for handled event' do
      setup { topic.find_all Coffee::BrewedEvent.new }

      asserts(:first).equals CoffeeViews::CounterView
    end

    context 'when find_all for unhandled event' do
      setup { topic.find_all Coffee::SpilledEvent.new }

      asserts_topic.empty
    end
  end
end
