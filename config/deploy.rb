set :application, "broncodashboard"
set :repository,  "svn+ssh://208.53.44.52/usr/local/svn/broncodashboard"
set :deploy_to, "/usr/local/rails/#{application}"
set :runner, 'deploy'
set :svn, "/usr/bin/svn"
set :ssh, "/usr/bin/ssh"
set :user, 'deploy'
ssh_options[:port] = 2022

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

desc "start thin web server"
task :start_thin do
  run "cd #{release_path} && /usr/bin/thin start -C config/thin.yml -d"
end
after "deploy:restart", "start_thin"