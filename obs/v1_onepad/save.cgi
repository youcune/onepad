#!/usr/bin/ruby -Ku

# OnePad
# save.cgi v0.1

require 'lib/puu'
require 'lib/data_access'
require 'lib/const'

da = DataAccess.new

puts('Content-type: application/json; charset=UTF-8')
puts()

begin
	# 詰め替え
	model = da.get_pad(p_textbox('pid'))
	model.text = p_textarea('text')
	model.host = gethostbyaddr(ENV['REMOTE_ADDR'])
	model.agent = ENV['HTTP_USER_AGENT']
	model.saved_with = get_terminal(ENV['HTTP_USER_AGENT'])
	
	# 保存
	if p_textbox('action') == Const::Status::MANUALLY_SAVED then
		da.manual_save_pad(model)
	elsif p_textbox('action') == Const::Status::AUTOMATICALLY_SAVED then
		da.auto_save_pad(model)
	else
		raise('Unknown Action: ' + p_textbox('action'))
	end
rescue => exc
	puts('{"status":0}')
else
	puts('{"status":1}')
end
