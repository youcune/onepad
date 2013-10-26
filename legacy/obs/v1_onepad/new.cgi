#!/usr/bin/ruby -Ku

# OnePad
# new.cgi v0.1

require 'lib/const'
require 'lib/data_access'

da = DataAccess.new
puts('Location: ' + Const::Config::ROOT_URL + da.create_new_pad(gethostbyaddr(ENV['REMOTE_ADDR']), ENV['HTTP_USER_AGENT']))
puts()
