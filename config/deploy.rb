set :application, "broncodashboard"
set :user, 'deploy'

set :scm, :git
set :deploy_via, :remote_cache
set :repository,  "git@10.0.0.107:/var/git/broncodashboard.git"
set :deploy_via, :copy
set :copy_cache, true

set :deploy_to, "/usr/local/rails/#{application}"
set :runner, 'deploy'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "208.53.44.52"
role :web, "208.53.44.52"
role :db,  "208.53.44.52", :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

desc "Update the polls"
task :update_polls do
  run "/usr/local/rails/broncodashboard/current/script/runner 'Scoreboard.update_polls' -e production"
end
after "deploy:restart", "update_polls"
