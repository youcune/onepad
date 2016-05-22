source 'https://rubygems.org'

# Rails
gem 'rails', '~> 4.2.6'

# Views
gem 'hamlit-rails'
gem 'jbuilder'

# Assets
gem 'coffee-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'font-awesome-sass'
gem 'therubyracer'

# Markdown Parser
gem 'rdiscount'

# APP Server
gem 'puma'

group :development, :test do
  # Database
  gem 'sqlite3'

  # Debugging
  gem 'byebug'
  gem 'better_errors'

  # Specs
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'

  # CLI Tools
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-kickstarter'
end

group :staging, :production do
  gem 'pg'
end
