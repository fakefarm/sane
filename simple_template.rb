remove_file "README.rdoc"
create_file "README.md", "TODO"

# test

# markup & styling
append_file 'Gemfile', "gem 'slim'"
append_file 'Gemfile', "gem 'neat'"

# debug
append_file 'Gemfile', "gem 'pry'"
append_file 'Gemfile', "gem 'xray'"


# users
append_file 'Gemfile', "gem 'devise'"


# git init

if yes? "Do you want to generate a root controller?"
  name = ask("What should it be called?").underscore
  generate :controller, "#{name} index"
  route "root to: '#{name}\#index'"
end

