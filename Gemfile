source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Assets Libraries
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 4.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Markdown Parser
gem 'rdiscount'

# For Development Environments
group :development, :test do
  # Database
  gem 'sqlite3'

  # For Debugging
  gem 'byebug'
  gem 'better_errors'

  # For Testing
  gem 'rspec', '~> 2.99.0.beta1'
  gem 'rspec-rails', '~> 2.99.0.beta1'
  gem 'rspec-kickstarter'
  gem 'capybara'
  gem 'turnip'

  # misc
  gem 'spring'
end

# For Production Environments
group :staging, :production do
  gem 'pg'
  gem 'unicorn'
  gem 'execjs'
  gem 'therubyracer'
end

