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

    should("add the new events to storage") {
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
        mock(topic.storage).add first_ar_events
        mock(topic.storage).add second_ar_events
  
        topic.commit
      }
    end
  end

end
