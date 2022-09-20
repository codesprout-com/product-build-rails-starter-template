def source_paths
  [__dir__]
end

# gems
gem 'bulma-rails', '~> 0.9.3'
gem 'devise',      '~> 4.8.1'
gem 'sidekiq',     '~> 6.4.2'

# generators
generate "devise:install"
generate :devise, "User", "name", "admin:boolean"

# environment config
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

inject_into_file "config/initializers/devise.rb", after: "# ==> Navigation configuration" do <<-DEVISE_CONFIG
\n  config.navigational_formats = ['*/*', :html, :turbo_stream]
DEVISE_CONFIG
end

# routing
route "root to: 'home#index'"

# copy files
remove_file "app/controllers/concerns/.keep"
directory "app/controllers"

remove_file "app/views/layouts/application.html.erb"
remove_file "app/views/layouts/mailer.html.erb"
directory "app/views"
directory "app/views/devise"

remove_file "app/assets/config/manifest.js"
remove_file "app/assets/stylesheets/application.css"
directory "app/assets"

# run rails commands
rails_command("db:create")
rails_command("db:migrate")

# commit newly generated application
after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'First commit' }
end

