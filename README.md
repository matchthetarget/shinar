# Shinar

A multilingual chat application that allows users to communicate across language barriers.

## Setup

1. Clone the repository
2. Install Ruby dependencies:
   ```
   bundle install
   ```
3. Install JavaScript dependencies:
   ```
   yarn install
   ```
4. Setup the database:
   ```
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

## Development

### Running the Server

Use Foreman to run the development server which will start the Rails server, JavaScript bundling, and CSS processing in parallel:

```
bin/dev
```

This will start:
- Rails server on http://localhost:3000
- JS build process with esbuild (watching for changes)
- CSS build process with Sass (watching for changes)

### Bundling

This application uses:
- `jsbundling-rails` with esbuild for JavaScript
- `cssbundling-rails` with Sass for CSS
- Bootstrap 5 for UI components

## Database Structure

```
rails generate scaffold user name:string
```

```
rails generate scaffold chat token:string creator:references subject:string
```

```
rails generate scaffold chat_user chat:references user:references
```

```
rails generate scaffold message chat:references author:references content:text parent:references
```
