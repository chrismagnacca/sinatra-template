## Getting Started

Setup With & On:
* [Sinatra](https://github.com/sinatra/sinatra)
* [Postgres](http://www.postgresql.org/)
* [Puma](https://github.com/puma/puma)

## Starting Up

install the necessary gems using:
```ruby
bundle
```

run the application using:
```ruby
puma
```

## Modular Layout

### Routes
routes are defined in config.ru
```ruby
map "/<route>" do run Tipplii::Routes::<route> end
```

### Models
* db models are defined under models/
* db migrations are defined under db/

###  Initializers

setup a secret key for the rack::session prior to running the application & place it in config/initializers/secret_token.rb
```ruby
SecureRandom.hex(64) #=> generates 64 hex token
```

## Database Connection Information

defined within config/database.yml
```yaml
<environment>:
  adapter: <database_adapter>
  database: <database_name>
  host: <host>
  username: <username>
  encoding: utf8
```

## Puma Setup

defined within config/puma.rb
```ruby
on_worker_boot do
 #=> runs before each individual worker begins
end
```

## Development

### Creating ActiveRecord Migrations

create a new migration using:
```ruby
rake db:create_migration NAME=<name_of_migration> RACK_ENV=<environment>
```

migrate to the latest database using:
```ruby
rake db:migrate
```

migrate to a specific database migration using:
```ruby
rake db:migrate VERSION=<selected_migration> RACK_ENV=<environment>
```

rollback to the previous migration using:
```ruby
rake db:rollback RACK_ENV=<environment>
```

## Testing & Debugging

### Running RSpec Tests
```ruby
rake spec RACK_ENV=<environment>
```

### Application Console
```ruby
RACK_ENV=<environment> tux
```

### Running Guard
Guard will auto-run tests after a change has been saved and output the results via OSX notification center (GNTP can be added as well).
```ruby
[bundle exec] guard
```
