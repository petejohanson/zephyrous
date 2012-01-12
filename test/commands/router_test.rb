
require 'teststrap'

class BrewCoffeeCommand
end

class BrewCoffeeCommandHandler
end

class FrothMilkCommandHandler
end

module PetesCoffeeDeluxe
  class BrewCoffeeCommand
  end

  class FrothMilkCommand
  end
  
  class BrewCoffeeCommandHandler
  end
end

context 'given a router' do
  setup { Zephyrous::Commands::Router.new }

  context 'with no namespaces added' do
    asserts("finds handler from root namespace") do
      topic.find_handler(BrewCoffeeCommand.new)
    end.kind_of(BrewCoffeeCommandHandler)
  end

  context 'with a namespace added' do
    hookup { topic.add_namespace PetesCoffeeDeluxe }

    asserts("finds handler from the namespace") {
      topic.find_handler(PetesCoffeeDeluxe::BrewCoffeeCommand.new)
    }.kind_of(PetesCoffeeDeluxe::BrewCoffeeCommandHandler)

    asserts("falls back to finding handler from the root namespace") {
      topic.find_handler(PetesCoffeeDeluxe::FrothMilkCommand.new)
    }.kind_of(FrothMilkCommandHandler)

  end
end
