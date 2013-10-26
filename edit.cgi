#!/usr/bin/ruby -Ku

# OnePad
# edit.cgi v0.1

require 'lib/init'
require 'lib/data_access'

da = DataAccess.new

puts('Content-type: text/html; charset=UTF-8')
puts()
header_html = load('theme/header.html')
header_html.gsub!(/\$\$ONEPAD_ROOT_DIR\$\$/, Init::ONEPAD_ROOT_DIR)
header_html.gsub!(/\$\$SCRIPT_FILE\$\$/, "pad.js")
print(header_html)
puts('<div id="container">')

begin
	if p_integer('rev') == 0 then
		model = da.get_pad(p_textbox('pid'))
	else
		model = da.get_pad_with_rev(p_textbox('pid'), p_integer('rev'))
	end
	
	print <<-"END_OF_HTML"
		<textarea class=\"text\" id=\"textarea\" wrap=\"soft\">#{model.text}</textarea>
		<div class=\"text\" id=\"textdiv\"></div>
	</div>
	<div id="footer">
		<div id="count"></div>
		<div>
			<input type="hidden" name="pid" id="pid" value="#{model.pid}">
			<button id="save"></button>
		</div>
	</div>
	END_OF_HTML
rescue => exc
	puts("<p>#{exc.message}</p>")
	puts("</body></html>");
end

# text : 328px
# link : rest


print(load('theme/footer.html'))
