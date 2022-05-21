# Eventish

[![Gem Version](https://badge.fury.io/rb/eventish.svg)](https://badge.fury.io/rb/eventish)
[![Specs](https://github.com/blocknotes/eventish/actions/workflows/main.yml/badge.svg)](https://github.com/blocknotes/eventish/actions/workflows/main.yml)

Yet another opinionated events library which proposes a simple API to handle... events 🎉

The main features:
- _composable_: just require the components that you need;
- with [adapters](#adapters): support ActiveSupport::Notifications for pub/sub events;
- with [async events](#async-events): support ActiveJob for background execution;
- with [callbacks wrapper](#callbacks): support ActiveRecord.
- with [plugins](#plugins): logger and Rails logger included.

## Install

- Add to your Gemfile: `gem 'eventish'` (and execute `bundle`)
- Create an initializer - _config/initializers/eventish.rb_:

```rb
require 'eventish/adapters/active_support'

Eventish.setup do |config|
  config.adapter = Eventish::Adapters::ActiveSupport
end

Rails.configuration.to_prepare do
  # NOTE: required to load the event descendants when eager_load is off
  unless Rails.configuration.eager_load
    events = Rails.root.join('app/events/**/*.rb').to_s
    Dir[events].sort.each { |event| require event }
  end
end

Rails.configuration.after_initialize do
  Eventish::SimpleEvent.subscribe_all # NOTE: events will be available after this point

  Eventish.publish('app_loaded') # just a test event
end
```

- Create some events - _app/events/main/app_loaded_event.rb_:

```rb
module Main
  class AppLoadedEvent < Eventish::SimpleEvent
    def call(_none, _options = {})
      puts '> App loaded event'
    end
  end
end
```

For a complete example please take a look at the [dummy app](spec/dummy) in the specs.

### Adapters

Only _ActiveSupport_ is supported for now.

```rb
# initializer setup
require 'eventish/adapters/active_support'

Eventish.setup do |config|
  config.adapter = Eventish::Adapters::ActiveSupport
end
```

### Simple events

Generic events not related to a specific component.

```rb
# initializer setup
Rails.configuration.after_initialize do
  # Subscribe all Eventish::SimpleEvent descendants using the configured adapter
  # The descendants event classes must be loaded before this point - see eager_load notes in the Install section
  Eventish::SimpleEvent.subscribe_all
end
```

Sample event - _app/events/main/test_event.rb_:

```rb
module Main
  class TestEvent < Eventish::SimpleEvent
    def call(_none, _options = {})
      puts '> A test event'
    end

    class << self
      def event_name
        # this is optional, if not set the class name to string will be used
        'some_event'
      end
    end
  end
end
```

Publish the event: `Eventish.publish('some_event')`

### Async events

Events executed in a background process. Only _ActiveJob_ is supported for now.

```rb
# initializer setup
require 'eventish/active_job_event'

Rails.configuration.after_initialize do
  Eventish::ActiveJobEvent.subscribe_all
end
```

Sample event - _app/events/notifications/user_after_save_commit_event.rb_:

```rb
module Notifications
  class UserAfterCommitEvent < Eventish::ActiveJobEvent
    def call(user, _options = {})
      Rails.logger.info ">>> User ##{user.id} after commit notification"
    end
  end
end
```

### Callbacks

Only for ActiveRecord, callbacks wrapper are available with the postfix `_event` (ex. `after_commit_event SomeEvent`).

```rb
# initializer setup
require 'eventish/active_record/callback'
```

```rb
class SomeModel < ActiveRecord::Base
  extend ::Eventish::ActiveRecord::Callback

  before_validation_event SomeBeforeValidationEvent
end
```

The related callback will be setup by the wrapper and the specified event class will be invoked accordingly.

### Plugins

A plugins system is available for custom processing, a logger and a Rails logger are included in the gem.

```rb
# initializer setup
require 'eventish/plugins/rails_logger' # without rails_ for a simple stdout logger

Eventish.setup do |config|
  config.before_event = [Eventish::Plugins::RailsLogger]
  config.after_event = [Eventish::Plugins::RailsLogger]
end
```

A sample plugin:

```rb
module Eventish::Plugins::RailsLogger
  class << self
    def call(target, _args, event:, hook: nil, &_block)
      Rails.logger.debug "EVENT: #{hook} #{event.class.event_name} on #{target.inspect}"
    end
  end
end
```

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

Or consider offering me a coffee, it's a small thing but it is greatly appreciated: [about me](https://www.blocknot.es/about-me).

## Contributors

- [Mattia Roccoberton](https://www.blocknot.es): author

## License

The gem is available as open-source under the terms of the [MIT](LICENSE.txt).
