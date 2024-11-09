# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path


# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w[ admin.js admin.css ]
Rails.application.config.assets.precompile += %w( blacklight/blacklight.js )


bl_dir = Bundler.rubygems.find_name('blacklight').first.full_gem_path
assets_path = File.join(bl_dir, 'app', 'javascript')
Rails.application.config.assets.paths << assets_path