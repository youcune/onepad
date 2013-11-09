env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'staging'
listen "/www/onepad/#{env}/tmp/sockets/#{env}.sock"
worker_processes 3
pid "/www/onepad/#{env}/tmp/pids/#{env}.pid"
