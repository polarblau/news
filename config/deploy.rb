# config valid only for current version of Capistrano
lock '3.4.0'

set :user, 'flo'
set :application, 'news_app'
set :repo_url, 'git@github.com:polarblau/news.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        execute :rvm, :exec, "bundle exec foreman export upstart /etc/init --procfile=./Procfile -a #{fetch(:application)} -u #{fetch(:user)} -l #{current_path}/log"
      end
    end

  end

  desc "Start the application services"
  task :start do
    on roles(:app) do
      within current_path do
        execute :rvm, :exec, "foreman start #{fetch(:application)}"
      end
    end

  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      within current_path do
        execute :rvm, :exec, "foreman stop #{fetch(:application)}"
      end
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      within current_path do
        execute :rvm, :exec, "foreman start #{fetch(:application)} || foreman restart #{fetch(:application)}"
      end
    end
  end
end

after "deploy:publishing", "foreman:export"
after "deploy:publishing", "foreman:restart"