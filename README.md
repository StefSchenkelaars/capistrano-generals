# Capistrano::Generals

Let capistrano take care of all your server setup. Upload stage specific config files and automated setup of nxing, puma, unicorn and sidekiq.

## Installation

Add this to your application's `Gemfile`:

```ruby
group :development do
  gem 'capistrano'
  gem 'capistrano-generals'
end
```

And then execute:

    $ bundle install

Create the capistrano `Capfile` if neccecary:

    $ bundle exec cap install

And add this to the `Capfile`:

```ruby
require 'capistrano/generals'
```

## Usage
When the generals package is added to the `Capfile`, the user can specify the required tasks.
In your `config/deploy.rb` you can add the taks by adding them to the deploy namespace like this:

```ruby
namespace :deploy do
  before :deploy,   'git:push'
  before :deploy,   'deploy:symlink:upload_linked_files'
  before :deploy,   'setup'
end
```

### Setup linked files
There are some tasks for linking configuration files to the system. It is
possible to use stage specific files like `config/nginx.staging.conf`. It will
then link this file to the system. If the stage specific file is not present,
it will look for the `config/nginx.conf` file. If that is absent as well it will
raise an error.
```ruby
cap <stage> setup:symlink:nginx    # Adds config/nginx.stage.conf to enabled nginx sites
cap <stage> setup:symlink:unicorn  # Adds config/unicorn_init.stage.sh to /etc/init.d scripts and add run at startup
cap <stage> setup:symlink:sidekiq  # Adds config/sidekiq_init.stag.sh to /etc/init.d scipts and add run at startup
```

### Git push
This first checks if there are no local changes that has not been committed.
If all changes are committed, they are pushed.

Options:

* IGNORE_DEPLOY_RB=true: This ignores changes in deploy.rb, for testing only!
* FORCE=true: Force push changes

### Upload linked files
This uploads the linked files. It first checks for a stage specific file so for
example you want to upload `database.yml` to the `staging` environment,
the system first searches for `database.staging.yml` and if it cannot find that
it will fall back to the original.

### Setup
TODO: Create docs. It creates config files and startup scripts for nginx, unicorn and sidekiq.

### Restart
This will upgrade the unicorn workers and restart nginx.

## Contributing

1. Fork it ( https://github.com/StefSchenkelaars/capistrano-generals/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Disclaimer
With ideas from:
* https://github.com/capistrano-plugins/capistrano-unicorn-nginx
* https://exceptiontrap.com/blog/11-create-and-install-ssl-certificates-with-ease-capistrano-recipe
