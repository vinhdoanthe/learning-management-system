Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( learning/prevent_inspect_code.js)
Rails.application.config.assets.precompile += %w( video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff )
Rails.application.config.assets.precompile += %w( ckeditor/config.js )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( learning/* )
Rails.application.config.assets.precompile += %w( learning/lesson_input.js )
Rails.application.config.assets.precompile += %w( admin/material.js )
Rails.application.config.assets.precompile += %w( social_community/* )
Rails.application.config.assets.precompile += %w( user/open_educat/op_students/public_profile.js)
Rails.application.config.assets.precompile += %w( user/*)
Rails.application.config.assets.precompile += %w( user/open_educat/op_students/batch_detail.js )
Rails.application.config.assets.precompile += %w( user/open_educat/op_students/homework.js )
Rails.application.config.assets.precompile += %w( social_community/dashboards/* )
Rails.application.config.assets.precompile += %w( social_community/dashboards.css )
Rails.application.config.assets.precompile += %w( redeem/* )
Rails.application.config.assets.precompile += %w( google_analytics.js )
Rails.application.config.assets.precompile += %w( materialize.min.js )
Rails.application.config.assets.precompile += %w( materialize.min.css )
Rails.application.config.assets.precompile += %w( loading.css )
Rails.application.config.assets.precompile += %w( social_community/question_answer/session_qa_area.js )
Rails.application.config.assets.precompile += %w( redeem/redeem_product_detail.css )
Rails.application.config.assets.precompile += %w( swiper.min.css )
Rails.application.config.assets.precompile += %w( swiper.min.js )
Rails.application.config.assets.precompile += %w( fotorama.css )
Rails.application.config.assets.precompile += %w( fotorama.js )
Rails.application.config.assets.precompile += %w( custom_js/opteacherjs.js )
Rails.application.config.assets.precompile += %w( jquery-fileupload/* )
Rails.application.config.assets.precompile += %w( user/open_educat/op_students/video.js )
Rails.application.config.assets.precompile += %w( user/open_educat/op_students/batch_detail.css )
Rails.application.config.assets.precompile += %w( adm/* )
Rails.application.config.assets.precompile += %w( user/open_educat/op_students/batches.css )
Rails.application.config.assets.precompile += %w( learning/learning.css )
Rails.application.config.assets.precompile += %w( user/open_educat/shared/timetable.js )
Rails.application.config.assets.precompile += %w( user/open_educat/op_teachers/teacher_class.css )
Rails.application.config.assets.precompile += %w( user/open_educat/op_teachers/teacher_class_detail.css )
Rails.application.config.assets.precompile += %w( user/open_educat/op_teachers/teacher_class.js )
Rails.application.config.assets.precompile += %w( social_community/refer_friend/refer_friend.js )
Rails.application.config.assets.precompile += %w( adm_application.css )
Rails.application.config.assets.precompile += %w( contest.css )
