listen "/www/onepad/#{Rails.env}/tmp/sockets/#{Rails.env}.sock"
worker_processes 3
pid "/www/onepad/#{Rails.env}/tmp/pids/#{Rails.env}.pid"
