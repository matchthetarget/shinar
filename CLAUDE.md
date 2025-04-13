# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- Run server: `bin/rails server`
- Run tests: `bin/rails test` or `bin/rails spec`
- Run specific test: `bin/rails test TEST=path/to/test_file.rb:line_number`
- Run specific spec: `bundle exec rspec spec/path/to/spec_file.rb:line_number`
- Generate sample data: `bin/rails sample_data`
- Linting: `bundle exec rubocop -A` (run before every commit)
- Database: `bin/rails db:migrate`, `bin/rails db:seed`, `bin/rails sample_data`

## Git

- Before every commit, `bundle exec rubocop -A`.
- Don't add Claude attribution.
- Write a great git commit message.

## UI

- This app should resemble Telegram, WhatsApp, iMessage, etc. When in doubt, follow their example.

## Code Style

- **Models**: Use ActiveRecord associations, validations, callbacks, and scopes idiomatically
- **Routes**: Nested resources for parent-child relationships (e.g., chats/messages)
- **Ruby**: 2-space indentation, snake_case for methods/variables
- **JavaScript**: 2-space indentation, camelCase for variables
- **Classes**: Follow Rails conventions with annotated schema
- **Error Handling**: Use ActiveRecord validations for data integrity
- **Testing**: Use RSpec for testing, FactoryBot for test data

## Architecture 

This is a standard Rails app using Hotwired/Stimulus for interactivity.
