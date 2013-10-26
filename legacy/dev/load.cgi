#!/usr/bin/ruby -Ku

# OnePad
# load.cgi v0.1

require 'lib/puu'
require 'lib/data_access'
require 'lib/const'
require 'json/pure'

da = DataAccess.new

puts('Content-type: application/json; charset=UTF-8')
puts()

begin
	# 詰め替え
	model = da.get_pad(p_textbox('pid'))
	pads  = [{"text" => model.text }]
	
	# 出力
	puts({ "status" => 1, "pads" => pads }.to_json)
rescue => exc
	puts([ "status" => 0 ].to_json)
end
