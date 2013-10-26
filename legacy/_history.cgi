#!/usr/bin/ruby -Ku

# OnePad
# history.cgi v0.1

require 'lib/puu'
require 'lib/data_access'
require 'lib/init'
require 'lib/const'

da = DataAccess.new

puts('Content-type: text/html; charset=UTF-8')
puts()
header_html = load('theme/header.html')
header_html.gsub!(/\$\$ONEPAD_ROOT_DIR\$\$/, Init::ONEPAD_ROOT_DIR)
print(header_html)

puts('<div id="container">')
puts('<div id="text">')
puts('<h2>どこまでもどりますか</h2>');

begin
	# 詰め替え
	da.get_pad_history(p_textbox('pid')).each do |model|
		puts('<div class="history">')
		url = Init::IS_MOD_REWRITTEN ? 
			"/#{model.pid}/#{model.id}" : 
			Init::ONEPAD_ROOT_DIR + "/edit.cgi?pid=#{model.pid};rev=#{model.id}"
			
		puts("	<div class=\"date\"><a href=\"#{url}\">#{model.saved_at[5..15]}" + (model.saved_with ? " Via #{model.saved_with}" : '') + "</a></div>")
		puts("	<div class=\"text\">#{model.text.flatten}</div>")
		puts('</div>')
	end
rescue => exc
	puts('<p>しっぱいしちゃった……。</p>')
end

puts('</div>')
puts('</div>')
puts('<div id="footer">')
puts('	<div>')
puts("		<button id=\"start\" class=\"active\" onclick=\"location.href='/#{p_textbox('pid')}';\">BACK</button>")
puts('	</div>')
puts('</div>')
print(load('theme/footer.html'))
