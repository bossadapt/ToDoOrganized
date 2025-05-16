require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# Nice to haves:
# TODO: allow mutliple assignees to the same project entry
# TODO: possibly add comments to actions so it can be used as a notifcation feed
# TODO: add filters to actions and project entries
# TODO: add true pagination or at least make it delete an action/comment off the pile before adding another
# TODO: make the home page a dashboard with the most recent actions , comments, available project entries
# TODO: some dev ops stuff like adding a just that dosnt have to redeploy the whole docker and can instead rewrite the internals
module ToDoOranized
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
    config.active_record.dump_schema_after_migration = false
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
