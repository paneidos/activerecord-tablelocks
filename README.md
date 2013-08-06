## ActiveRecord Tablelocks

This gem adds table locking functionality to ActiveRecord.
Every save and destroy action is already done using a transaction, but now you can add locking to this process to make sure you really have unique records.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-tablelocks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-tablelocks

## Usage

In your models use the following to lock the table when editing records:

    class User < ActiveRecord::Base
        validates :login, :uniqueness => true, :presence => true
        # The following line enables locking to make sure the uniqueness constraint holds.
        enable_locking
    end

If you need to lock multiple table, you can specify this in two ways.

Using class names:

    class EmailBox < ActiveRecord::Base
        enable_locking :class_names => ['EmailAlias']
        # The class name needs to be a String, but doesn't need to be in an Array.
        # Don't forget to add validations, this gem doesn't do that for you.
    end

Using table names:

    class EmailAlias < ActiveRecord::Base
        enable_locking :table_names => ['email_boxes']
        # The table name needs to be a String, but doesn't need to be in an Array.
        # The gem quotes the table name for you, so you don't need to that here.
        # Don't forget to add validations, this gem doesn't do that for you.
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
