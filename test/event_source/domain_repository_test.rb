require 'teststrap'

module Zephyrous
  module EventSource
    class DomainRepository
      def unit_of_work
        @unit_of_work ||= Object.new
      end
    end
  end
end

context "A domain repository" do
  setup { Zephyrous::EventSource::DomainRepository.new }

  should("track an aggregate root in the unit of work when added and") {
    mock(topic.unit_of_work).track('root').returns 'root'
    topic.add 'root'
  }.equals('root')

  should("find then add an aggregate root when finding") {
    mock(topic.unit_of_work).find(Object, '1234') { 'root' }
    mock(topic.unit_of_work).track('root') { 'root' }

    topic.find(Object,'1234')
  }.equals('root')
end
