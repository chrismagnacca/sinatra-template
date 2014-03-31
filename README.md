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
map "/<route>" do run Routes::<route> end
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
workers Integer(ENV["WORKERS"] || 3)
threads Integer(ENV["MIN_THREADS"]  || 1), Integer(ENV["MAX_THREADS"] || 16)

preload_app!

rackup  DefaultRackup
port  ENV["PORT"]  || 3000

on_worker_boot do
 # runs before each individual worker begins
 ENVIRONMENT = ENV["RACK_ENV"] || "development"
  DATABASE_CONFIG_FILE = ENV["DATABASE_CONFIG_FILE"] || YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/database.yml")))

  ENV["SESSION_SECRET"] = YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/initializers/secret_token.rb")))["token"]

  # establish database connection
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection(DATABASE_CONFIG_FILE[ENVIRONMENT])
  end
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
