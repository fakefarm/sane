remove_file "README.rdoc"
create_file "README.md", "TODO"

gem 'rspec-rails', group: [:test, :development]

append_file 'Gemfile', <<-GEMFILE

# test

# markup & styling
group :development do
  gem 'slim'
  gem 'neat'
end

# debug
gem 'pry'
gem 'xray'


# users
# gem 'devise'


GEMFILE

run 'bundle install'
generate 'rspec:install'

if yes? "Do you want to add users with Devise?"
  name = ask("What should it be called?").underscore
end

git :init
git add: '.', commit: "-m 'initial commit'"



# ask about devise
# Test gems from everday rails - grouped properly

# gem 'awesome_print', :require => 'ap'
#   gem 'quiet_assets'
#   gem 'better_errors'
#   gem 'binding_of_caller'

# group :production do
#    gem 'pg'
#    gem 'rails_12factor'
# end
