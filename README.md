# Sorta::Transactions

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sorta/transactions`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sorta-transactions'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sorta-transactions

## Usage

> It's magic. I ain't gonna explain. Just run it.

```ruby
require 'sorta/transactions'

# I don't want to use something complex like dry-rb for this example so let's leave it with sorta-di
module Sorta
  module DI
    attr_reader :deps

    def initialize(deps = {})
      @deps = deps
    end
  end
end

class CreateOrder
  include Sorta::DI

  # after including this module you have to define 'commit' and 'rollback' methods
  include Sorta::Transactions::Service

  def commit(order)
    puts "creating order #{order[:id]}, repo: #{deps[:repo]}"
    deps[:repo].push order[:id]
    puts "order successfully created #{order[:id]}, repo: #{deps[:repo]}"

    raise "oh no" if order[:id] > 9000

    { sorta_monad: :success, result: :created_order }
  end

  # called if commit ended with error raised
  def rollback(order)
    puts "rollback order creation #{order[:id]}, repo: #{deps[:repo]}"
    deps[:repo].delete(order[:id])
    puts "order successfully deleted #{order[:id]}, repo: #{deps[:repo]}"
  end
end

class ComplexService
  include Sorta::DI
  include Sorta::Transactions::Handler

  def call(opts)
    _ = yield deps[:create_order].call(id: opts[:id])
    
    opts[:childs].each do |child_id| 
      _ = yield deps[:create_order].call(id: child_id)
    end

    { sorta_monad: :success }
  end
end

sorta_repo = [1,2,3]
opts = { id: 4, childs: [5, 9000, 9001] }
ComplexService.new(create_order: CreateOrder.new(repo: sorta_repo)).call(opts)
puts "repo after all things #{sorta_repo}"

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sorta-transactions. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/sorta-transactions/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sorta::Transactions project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sorta-transactions/blob/master/CODE_OF_CONDUCT.md).
