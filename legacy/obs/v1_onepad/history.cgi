#!/usr/bin/ruby -Ku

# OnePad
# history.cgi v0.1

require 'lib/puu'
require 'lib/data_access2'
require 'lib/const'

da = DataAccess.new

puts('Content-type: text/html; charset=UTF-8')
puts()

print(load('theme/header.html'))

puts('<div id="form">')
puts('<div id="text">')
puts('<h2>あのころにもどりたい</h2>');

begin
	# 詰め替え
	da.get_pad_history(p_textbox('pid')).each do |model|
		puts('<div class="history">')
		puts("	<div class=\"date\"><a href=\"/#{model.pid}/#{model.id}\">#{model.saved_at[5..15]}" + (model.saved_with ? " Via #{model.saved_with}" : '') + "</a></div>")
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
