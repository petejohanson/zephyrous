
require 'teststrap'

context 'given a propagator' do
  helper(:storage) { @storage ||= Object.new }
  helper(:bus) { @bus ||= Object.new }
  setup { Zephyrous::Events::Propagator.new(storage, bus) }

  helper(:new_events) { ['a', 'b'] }

  asserts('when iterating, it sends events to the event bus') do
    new_events.each { |ev| mock(bus).publish(ev) }
    mock(storage).process_new_events.returns { |ev_proc| ev_proc.call new_events }

    topic.iterate
  end
end
