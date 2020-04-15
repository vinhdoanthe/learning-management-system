Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( learning/prevent_inspect_code.js)
Rails.application.config.assets.precompile += %w( video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff )
Rails.application.config.assets.precompile += %w( ckeditor/config.js )
Rails.application.config.assets.precompile += %w(ckeditor/*)
Rails.application.config.assets.precompile += %w( learning/* )
Rails.application.config.assets.precompile += %w( learning/lesson_input.js )
Rails.application.config.assets.precompile += %w( admin/material.js )
Rails.application.config.assets.precompile += %w( social_community/sc_product.js )
Rails.application.config.assets.precompile += %w( user/open_educat/*)
