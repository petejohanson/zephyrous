require 'teststrap'

context "A domain repository" do
  helper(:unit_of_work) { @uow ||= Object.new }
  setup { Zephyrous::EventSource::DomainRepository.new(unit_of_work) }

  should("track an aggregate root in the unit of work when added and") {
    mock(unit_of_work).track('root').returns 'root'
    topic.add 'root'
  }.equals('root')

  should("find then add an aggregate root when finding") {
    mock(unit_of_work).find(Object, '1234') { 'root' }
    mock(unit_of_work).track('root') { 'root' }

    topic.find(Object,'1234')
  }.equals('root')
end
