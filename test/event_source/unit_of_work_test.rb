require 'teststrap'

module Zephyrous
  module EventSource
    class UnitOfWork
      def storage
        @storage ||= Object.new
      end
    end
  end
end

context "unit of work" do
  setup { Zephyrous::EventSource::UnitOfWork.new }
  context "with a tracked AR" do
    helper(:first_ar_events) { @first_ar_events ||= [:first] }
    helper(:first_ar) { @first_ar ||= Object.new }
    hookup do
      stub(first_ar).new_events { first_ar_events }
      topic.track(first_ar)
    end

    should("add the new events to storage with a transaction") {
      mock(topic.storage).transaction.returns { |t_proc| t_proc.call (topic.storage) }
      mock(topic.storage).add first_ar_events

      topic.commit
    }

    context 'and a second tracked AR' do
      helper(:second_ar_events) { @second_ar_events ||= [:second] }
      helper(:second_ar) { @second_ar ||= Object.new }
      hookup do
        stub(second_ar).new_events { second_ar_events }
        topic.track(second_ar)
      end

      should("add the first and second events to storage") {
        mock(topic.storage).transaction.returns { |t_proc| t_proc.call (topic.storage) }
        mock(topic.storage).add first_ar_events
        mock(topic.storage).add second_ar_events
  
        topic.commit
      }
    end
  end

  context 'when finding AR with a given guid' do
    should('return null when no events found') {
      guid = '123'
      stub(topic.storage).find_all(guid) { [] }

      topic.find(Object, guid)
    }.nil
    
    context 'and there are events for the guid' do
      helper(:ar) { @ar ||= Object.new }
      helper(:events) { @events ||= [ 'a', 'b' ] }
      helper(:guid) { @guid ||= '123' }
      hookup do
        stub(topic.storage).find_all(guid) { events }
        stub(Object).from_events(events) { ar }
      end

      should('instantiate the class and return it') {
        guid = '123'
        events = [ 'a', 'b' ]
  
        topic.find(Object, guid)
      }.equals do ar end

      context 'after finding the AR' do
        helper(:new_events) { @new_events ||= [ 'c', 'd' ] }
        hookup do
          stub(ar).new_events { new_events }
          topic.find(Object, guid)
        end

        should('commit changes to found AR when commiting') {
          mock(topic.storage).transaction.returns { |t_proc| t_proc.call (topic.storage) }
          mock(topic.storage).add new_events { true }

          topic.commit
        }
      end
    end
  end
end
