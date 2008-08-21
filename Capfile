load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

# ========================
#     For FCGI Apps
# ========================
# NB: running the following :start task will delete your main public_html directory.
# So don't use these commands if you have existing sites in here.

# namespace :deploy do
# 
#   task :start, :roles => :app do
#     #...
#   end
# 
#   task :restart, :roles => :app do
#     run "killall -u #{user} dispatch.fcgi"
#     run "cd #{current_path} && chmod 755 #{chmod755}"
#   end
#   
#   task :migrate do
#     # Do nothing
#   end
#   
# end

# ========================
#    For Mongrel Apps
# ========================

namespace :deploy do

  task :start, :roles => :app do
    # run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
    run "cd #{current_path} && mongrel_rails start -e production -p #{mongrel_port} -d"
  end
  
  task :stop, :roles => :app do
    # run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
    run "cd #{current_path} && mongrel_rails stop"
  end

  task :restart, :roles => :app do
    stop
    sleep 1
    start
    
    run "cd #{current_path} && chmod 755 #{chmod755}"
  end

end

# ========================
# For Mongrel Cluster Apps
# ========================

# namespace :deploy do
# 
#   task :start, :roles => :app do
#     run "cd #{current_path} && mongrel_rails cluster::configure -e production -p #{mongrel_port}0 -N #{mongrel_nodes} -c #{current_path} --user #{user} --group #{user}"
#     run "cd #{current_path} && mongrel_rails cluster::start"
#     run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
#     run "mkdir -p #{deploy_to}/shared/config"
#     run "mv #{current_path}/config/mongrel_cluster.yml #{deploy_to}/shared/config/mongrel_cluster.yml"
#     run "ln -s #{deploy_to}/shared/config/mongrel_cluster.yml #{current_path}/config/mongrel_cluster.yml"
#   end
# 
#   task :restart, :roles => :app do
#     run "ln -s #{deploy_to}/shared/config/mongrel_cluster.yml #{current_path}/config/mongrel_cluster.yml"
#     run "cd #{current_path} && mongrel_rails cluster::restart"
#     run "cd #{current_path} && chmod 755 #{chmod755}"
#   end
# 
# end