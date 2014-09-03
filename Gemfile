source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

# Views / Assets
gem 'haml-rails'
gem 'jbuilder'
gem 'coffee-rails'
gem 'uglifier'
gem 'sass-rails'
gem 'font-awesome-sass'

# Markdown Parser
gem 'rdiscount'

group :development, :test do
  # Database
  gem 'sqlite3'

  # Debugging
  gem 'byebug'
  gem 'better_errors'

  # Specs
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker', require: false
  gem 'simplecov', require: false

  # CLI Tools
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-kickstarter'
end

group :staging, :production do
  gem 'pg'
  gem 'unicorn'
  gem 'execjs'
  gem 'therubyracer'
end
