require 'teststrap'

class Person
  include Zephyrous::EventSource::Entity

  attr_reader :name, :email

  def self.create (name, email)
    Person.create_from_event CreatedEvent.new({ name: name, email: email })
  end

  def on_created(event)
    @name = event.name
    @email = event.email
  end

  class CreatedEvent
    include Zephyrous::EventSource::Event
  end
end

context 'for a simple AR' do
  helper(:name) { 'BRUCE LEE' }
  helper(:email) { 'bruce@lee.com' }

  context 'when creating a new AR' do
    setup { Person.create(name, email) }
  
    asserts(:new_events).size(1)
    asserts("the created event name") { topic.new_events.first.name }.equals { name }
    asserts("the created event email") { topic.new_events.first.email }.equals { email }
    asserts("the created event event-name") { topic.new_events.first.event_name }.equals('person_created')
    asserts(:name).equals { name }
    asserts(:email).equals { email }
  end

  context 'when loading the AR from existing events' do
    helper(:events) { [ Person::CreatedEvent.new({ name: name, email: email }) ] }
    setup { Person.from_events events }

    asserts(:new_events).empty
    asserts(:name).equals { name }
    asserts(:email).equals { email }
  end
end

