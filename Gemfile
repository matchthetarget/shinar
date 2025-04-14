source "https://rubygems.org"

# Rails core
gem "rails", "~> 8.0.2"
gem "propshaft"                    # Modern asset pipeline for Rails
gem "pg", "~> 1.1"                 # PostgreSQL database
gem "puma", ">= 5.0"               # Web server
gem "bootsnap", require: false     # Reduces boot times through caching

# Frontend
gem "importmap-rails"              # JavaScript with ESM import maps
gem "turbo-rails"                  # Hotwire's SPA-like page accelerator
gem "stimulus-rails"               # Hotwire's modest JavaScript framework
gem "jbuilder"                     # Build JSON APIs

# Rails services
gem "solid_cache"                  # Database-backed adapter for Rails.cache
gem "solid_queue"                  # Database-backed adapter for Active Job
gem "solid_cable"                  # Database-backed adapter for Action Cable

# DevOps
gem "kamal", require: false        # Docker container deployment
gem "thruster", require: false     # HTTP asset caching/compression for Puma

# Windows-specific
gem "tzinfo-data", platforms: %i[windows jruby]

# Feature gems
gem "kramdown"                     # Markdown parser
gem "rqrcode"                      # QR code generation
gem "active_link_to"               # Helper for creating active links
gem "simple_form"                  # Simplified form builder
gem "devise"                       # Authentication
gem "pundit"                       # Authorization
gem "ransack"                      # Search and filtering
gem "strip_attributes"             # Remove whitespace from model attributes
gem "validate_url"                 # URL validation
gem "carrierwave"                  # File uploads
gem "cloudinary"                   # Cloud image storage
gem "kaminari"                     # Pagination
gem "groupdate"                    # Group data by time periods

# Development and testing utilities
gem "awesome_print"                # Pretty print Ruby objects
gem "dotenv"                       # Load environment variables from .env
gem "faker"                        # Generate fake data
gem "htmlbeautifier"               # Format HTML
gem "http"                         # HTTP client
gem "table_print"                  # Format ActiveRecord for console

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false             # Security vulnerability scanner
  gem "rubocop-rails-omakase", require: false # Ruby code style
  gem "rspec-rails", "~> 7.1.1"              # Testing framework
  gem "grade_runner", "~> 0.0.13"            # Automated grading
end

group :development do
  gem "web-console"                # Console on exception pages
  gem "annotaterb"                 # Schema annotation for models
  gem "better_errors"              # Improved error pages
  gem "binding_of_caller"          # Interactive console on error pages
  gem "pry-rails"                  # Alternative console
  gem "rails-erd"                  # Generate ER diagrams
  gem "rufo"                       # Ruby code formatter
end

group :test do
  gem "shoulda-matchers", "~> 6.4"   # Additional matchers for RSpec
  gem "rspec-html-matchers"          # Matchers for HTML testing
  gem "rails-controller-testing"     # Testing for controllers
  gem "webmock"                      # Mock HTTP requests
  gem "capybara"                     # Browser testing
  gem "selenium-webdriver", "~> 4.11.0" # Browser automation
  gem "webdrivers"                   # Browser drivers
end
