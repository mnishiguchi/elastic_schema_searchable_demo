require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ElasticSchemaSearchableDemo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << "#{config.root}/app/searches"

    # Configure Browserify to use babelify to compile ES6
    config.browserify_rails.commandline_options = "-t [ babelify --presets [ es2015 ] ]"
  end
end
