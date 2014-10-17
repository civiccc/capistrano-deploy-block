# Capistrano::DeployBlock

Provides simple commands for blocking Capistrano deploys.

## Motivation

Sometimes (hopefully rarely) situations will arise where you need to prevent
other developers from deploying the application. While you can usually send
out a warning via chat or email, it might not get seen in time. It would be
useful to be able to display a warning before they actually try to deploy.

The `capistrano-deploy-block` plugin aims to make this easy by defining two
tasks for blocking (`deploy:block`) and unblocking (`deploy:unblock`) deploys
for your application.

## Requirements

* Ruby 1.9.3+
* Capistrano 3

## Installation

1. Add the following to your application's `Gemfile`:

   ```ruby
   gem 'capistrano-deploy-block'
   ```

   ...and then execute `bundle install`.

2. Add the following to your application's `Capfile`:

   ```ruby
   require 'capistrano/deploy_block'
   ```

3. Specify which server you want to use to store whether or not deploys are
   blocked. A simple choice is to pick one of your application servers. Note
   that this must be **one** server, not a collection.

   ```ruby
   # config/deploy.rb
   set :deploy_block_host, -> { primary(:app) }
   ```

## Usage

To block deploys, simply execute:

```bash
cap <stage> deploy:block
```

To unblock deploys, execute:

```bash
cap <stage> deploy:unblock
```

### What happens when you block deploys?

After blocking a deploy, any engineer who attempts to deploy will get an error
message like the following:

```
johndoe blocked deploys at 2014-10-16 11:46:13 -0700
```

### Who can unblock a deploy?

**Anyone can unblock a deploy**. The goal is not to have one person be in
control of deploys, but to warn others that deploying is currently unsafe and
that they should coordinate.

## Configuration

The following options are configurable.

```ruby
# Message displayed to users who attempt to deploy when deploys are blocked
set :deploy_block_message, -> { "#{local_user} blocked deploys at #{Time.now}" }

# File created on the deploy_block_host to signal that a deploy is blocked
set :deploy_block_file, -> { File.join(shared_path, 'deploy-block') }

# The host where the deploy block file is stored
set :deploy_block_host, -> { primary(:app) }
```

## License

This project is released under the [MIT license](LICENSE)
