source "https://rubygems.org"

# Rails core
gem "bootsnap", require: false     # Reduces boot times through caching
gem "pg", "~> 1.1"                 # PostgreSQL database
gem "propshaft"                    # Modern asset pipeline for Rails
gem "puma", ">= 5.0"               # Web server
gem "rails", "~> 8.0.2"

# Frontend
gem "importmap-rails"              # JavaScript with ESM import maps
gem "jbuilder"                     # Build JSON APIs
gem "stimulus-rails"               # Hotwire's modest JavaScript framework
gem "turbo-rails"                  # Hotwire's SPA-like page accelerator

# Rails services
gem "solid_cable"                  # Database-backed adapter for Action Cable
gem "solid_cache"                  # Database-backed adapter for Rails.cache
gem "solid_queue"                  # Database-backed adapter for Active Job

# DevOps
gem "kamal", require: false        # Docker container deployment
gem "thruster", require: false     # HTTP asset caching/compression for Puma

# Windows-specific
gem "tzinfo-data", platforms: %i[windows jruby]

# Feature gems
gem "active_link_to"               # Helper for creating active links
gem "carrierwave"                  # File uploads
gem "cloudinary"                   # Cloud image storage
gem "devise"                       # Authentication
gem "groupdate"                    # Group data by time periods
gem "kaminari"                     # Pagination
gem "kramdown"                     # Markdown parser
gem "pundit"                       # Authorization
gem "ransack"                      # Search and filtering
gem "rqrcode"                      # QR code generation
gem "simple_form"                  # Simplified form builder
gem "strip_attributes"             # Remove whitespace from model attributes
gem "validate_url"                 # URL validation

# Development and testing utilities
gem "awesome_print"                # Pretty print Ruby objects
gem "dotenv"                       # Load environment variables from .env
gem "faker"                        # Generate fake data
gem "haikunator"                   # Generate attractive random usernames
gem "htmlbeautifier"               # Format HTML
gem "http"                         # HTTP client
gem "table_print"                  # Format ActiveRecord for console

group :development, :test do
  gem "brakeman", require: false             # Security vulnerability scanner
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "grade_runner", "~> 0.0.13"            # Automated grading
  gem "rspec-rails", "~> 7.1.1"              # Testing framework
  gem "rubocop-rails-omakase", require: false # Ruby code style
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
  gem "capybara"                     # Browser testing
  gem "rails-controller-testing"     # Testing for controllers
  gem "rspec-html-matchers"          # Matchers for HTML testing
  gem "selenium-webdriver", "~> 4.11.0" # Browser automation
  gem "shoulda-matchers", "~> 6.4"   # Additional matchers for RSpec
  gem "webdrivers"                   # Browser drivers
  gem "webmock"                      # Mock HTTP requests
end
