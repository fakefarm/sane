# ========================================================================
# Misc
# ========================================================================

empty_directory 'app/services'


# ========================================================================
## SMACSS
# ========================================================================

empty_directory 'app/assets/stylesheets/base'
empty_directory 'app/assets/stylesheets/layout'
empty_directory 'app/assets/stylesheets/modules'
empty_directory 'app/assets/stylesheets/settings'
empty_directory 'app/assets/stylesheets/state'

create_file 'app/assets/stylesheets/base/_base.scss'
create_file 'app/assets/stylesheets/base/_typography.scss'
create_file 'app/assets/stylesheets/layout/_layouts.scss'
create_file 'app/assets/stylesheets/settings/_colors.scss'
create_file 'app/assets/stylesheets/settings/_typography.scss'

remove_file "app/assets/stylesheets/application.css"
create_file "app/assets/stylesheets/application.scss", <<-INCLUDES

// Libraries
@import 'bourbon';
@import 'neat';

// Settings
@import 'settings/typography';
@import 'settings/colors';

// Base
@import 'base/base';
@import 'base/typography';

// Layout
@import 'layout/layouts';

INCLUDES


# ========================================================================
# Devise
# ========================================================================

if yes? "Do you want to add users with Devise?"
  inject_into_file 'Gemfile', after: "gem 'rails', '4.0.0'" do
    <<-GEM
gem 'devise'
    GEM
  end

  inject_into_file 'config/environments/development.rb', after: "config.cache_classes = false" do
    <<-CONFIG

    "config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
    CONFIG
  end
end


# ========================================================================
# Gemfile
# ========================================================================

gsub_file('Gemfile', /# Use sqlite3 as the database for Active Record/, '')
gsub_file('Gemfile', /gem 'sqlite3'/, '')
gsub_file('Gemfile', /# Use ActiveModel has_secure_password/, '')
gsub_file('Gemfile', /# gem 'bcrypt-ruby', '~> 3.0.0'/, '')
gsub_file('Gemfile', /# Use unicorn as the app server/, '')
gsub_file('Gemfile', /# gem 'unicorn'/, '')
gsub_file('Gemfile', /# Use Capistrano for deployment/, '')
gsub_file('Gemfile', /# gem 'capistrano', group: :development/, '')
gsub_file('Gemfile', /# Use debugger/, '')
gsub_file('Gemfile', /# gem 'debugger', group: [:development, :test]/, '')

inject_into_file 'Gemfile', after: "gem 'rails', '4.0.0'" do
<<-GEMFILE


group :development, :test do
  gem 'rspec-rails', '~> 2.14.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'awesome_print', :require => 'ap'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
  gem 'xray-rails'
  gem 'sqlite3'
end

group :test do
  gem 'faker', '~> 1.1.2'
  gem 'capybara', '~> 2.1.0'
  gem 'database_cleaner', '~> 1.0.1'
  gem 'launchy', '~> 2.3.0'
  gem 'selenium-webdriver', '~> 2.35.1'
end

group :production do
   gem 'pg'
   gem 'rails_12factor'
end

gem 'slim-rails'
gem 'neat'
GEMFILE
end


# ========================================================================
# Initialize
# ========================================================================

run 'bundle install'
generate 'rspec:install'
generate 'devise:install'
generate 'devise User'
generate 'devise:views'


# ========================================================================
# Database
# ========================================================================

run 'rake db:create:all'
run 'rake db:migrate'
run 'rake db:test:clone'


# ========================================================================
# Generator Overrides
# ========================================================================

inject_into_file 'config/application.rb', after: "class Application < Rails::Application" do

  <<-CONFIG


    config.generators do |g|
      g.test_framework :rspec,
        fixtures:         true,
        view_specs:       false,
        helper_specs:     false,
        routing_specs:    false,
        controller_specs: true,
        request_specs:    false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.stylesheets = false
      g.javascripts = false
    end
  CONFIG
end


# ========================================================================
# Readme
# ========================================================================

remove_file "README.rdoc"
create_file "README.md", <<-README
## A New project by [Dave Woodall](http://www.hireDave.me)
Readme is coming soon.
- [@hireDave](http://www.twitter.com/hireDave)

### DEVISE TODO's

1. In production, :host should be set to the actual host of your application.

    config.action_mailer.default_url_options = { :host => 'localhost:3000' }

2. Ensure you have defined root_url to *something* in your config/routes.rb.
For example:

    root :to => "home#index"

3. Ensure you have flash messages in app/views/layouts/application.html.erb.
For example:

    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
README


# ========================================================================
# Git Repo
# ========================================================================

git :init
git add: '.', commit: "-m 'initial commit'"
