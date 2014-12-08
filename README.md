# Capistrano::Generals

Capistrano tasks that are used quite often.
Push your code to git, upload stage specific config files.

## Installation

Add this to your application's `Gemfile`:

```ruby
group :development do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-unicorn-nginx', '~> 3.1.0'
end
```

And then execute:

    $ bundle install

And add this to the `Capfile`:

```ruby
require 'capistrano/generals'
```

## Usage
When the generals package is added to the `Capfile`, the user can specify the required tasks.
In your `config/deploy.rb` you can add the taks by adding them to the deploy namespace like this:

```ruby
namespace :deploy do
  before :deploy, 'git:push'
  before :deploy, 'deploy:symlink:upload_linked_files'
end
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


## Contributing

1. Fork it ( https://github.com/[my-github-username]/capistrano-generals/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
