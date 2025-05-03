source "https://rubygems.org"

# Rails core
gem "bootsnap", require: false     # Reduces boot times through caching
gem "pg", "~> 1.1"                 # PostgreSQL database
gem "propshaft"                    # Modern asset pipeline for Rails
gem "puma", ">= 5.0"               # Web server
gem "rails", "~> 8.0.2"

# Frontend
gem "jsbundling-rails"             # Bundle and transpile JavaScript
gem "jbuilder"                     # Build JSON APIs
gem "stimulus-rails"               # Hotwire's modest JavaScript framework
gem "turbo-rails"                  # Hotwire's SPA-like page accelerator

# Rails services
gem "redis", "~> 4.0"                  # Redis client
gem "hiredis"                       # Faster Redis client
gem "solid_cache"                  # Database-backed adapter for Rails.cache
gem "solid_queue"                  # Database-backed adapter for Active Job

# DevOps
gem "kamal", require: false        # Docker container deployment
gem "thruster", require: false     # HTTP asset caching/compression for Puma
gem "rollbar"

# Windows-specific
gem "tzinfo-data", platforms: %i[windows jruby]

# Feature gems
gem "active_link_to"               # Helper for creating active links
gem "ai-chat", "< 1.0.0"           # Makes it easy to chat with LLMs
gem "carrierwave"                  # File uploads
gem "cloudinary"                   # Cloud image storage
gem "devise"                       # Authentication
gem "dotenv"                       # Load environment variables from .env
gem "groupdate"                    # Group data by time periods
gem "haikunator"                   # Generate attractive random usernames
gem "kaminari"                     # Pagination
gem "kramdown"                     # Markdown parser
gem "kramdown-parser-gfm"          # GitHub Flavored Markdown parser
gem "pundit"                       # Authorization
gem "ransack"                      # Search and filtering
gem "rqrcode"                      # QR code generation
gem "simple_form"                  # Simplified form builder
gem "strip_attributes"             # Remove whitespace from model attributes
gem "validate_url"                 # URL validation

group :development, :test do
  gem "brakeman", require: false   # Security vulnerability scanner
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "grade_runner", "~> 0.0.13"  # Automated grading
  gem "rspec-rails", "~> 7.1.1"    # Testing framework
  gem "rubocop-rails-omakase", require: false # Ruby code style
  gem "awesome_print"              # Pretty print Ruby objects
  gem "htmlbeautifier"             # Format HTML
  gem "table_print"                # Format ActiveRecord for console
end

group :development do
  gem "annotaterb"                 # Schema annotation for models
  gem "better_errors"              # Improved error pages
  gem "binding_of_caller"          # Interactive console on error pages
  gem "pry-rails"                  # Alternative console
  gem "rails-erd"                  # Generate ER diagrams
  gem "rufo"                       # Ruby code formatter
  gem "web-console"                # Console on exception pages
end

group :test do
  gem "capybara"                   # Browser testing
  gem "rails-controller-testing"   # Testing for controllers
  gem "rspec-html-matchers"        # Matchers for HTML testing
  gem "selenium-webdriver", "~> 4.11.0" # Browser automation
  gem "shoulda-matchers", "~> 6.4" # Additional matchers for RSpec
  gem "webdrivers"                 # Browser drivers
  gem "webmock"                    # Mock HTTP requests
end
