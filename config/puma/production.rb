environment 'production'
threads 4, 4
workers 2
pidfile "#{Dir.pwd}/tmp/pids/puma.pid"
state_path "#{Dir.pwd}/tmp/pids/puma.state"
bind "unix://#{Dir.pwd}/tmp/puma.sock"
stdout_redirect "#{Dir.pwd}/log/puma.log", "#{Dir.pwd}/log/puma.log", true
preload_app!
