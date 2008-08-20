default_run_options[:pty] = true
`ssh-add`

set :application, "latestchatty"
set :domain,      "beautifulpixel.com"
set :user,        "squeegy"

set :scm,         :git
set :repository,  "git@github.com:Squeegy/latest-chatty-api.git"
set :deploy_via,  :remote_cache
set :ssh_options, {
  :forward_agent => true
}

set :use_sudo,    false
set :deploy_to,   "/home/#{user}/sites/#{application}"
set :chmod755,    "config public vendor script script/* public/disp*"

set :mongrel_port, "41746"               # Mongrel port that was assigned to you
# set :mongrel_nodes, "4"                # Number of Mongrel instances for those with multiple Mongrels

role :app, domain
role :web, domain
role :db,  domain, :primary => true