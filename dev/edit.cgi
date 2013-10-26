#!/usr/bin/ruby -Ku

# OnePad
# edit.cgi v0.1

require 'lib/init'
require 'lib/data_access'

puts('Content-type: text/html; charset=UTF-8')
puts()
header_html = load('theme/header.html')
header_html.gsub!(/\$\$ONEPAD_ROOT_DIR\$\$/, Init::ONEPAD_ROOT_DIR)
header_html.gsub!(/\$\$SCRIPT_FILE\$\$/, "pad.js")
print(header_html)
puts('<div id="container">')

print <<"END_OF_HTML"
	<textarea class=\"text\" id=\"textarea\" wrap=\"soft\">Loading...</textarea>
	<div class=\"text\" id=\"textdiv\">Loading...</div>
</div>
<div id="footer">
	<div id="count"></div>
	<div>
		<input type="hidden" name="pid" id="pid" value="#{p_textbox('pid')}">
		<button id="save"></button>
	</div>
</div>
END_OF_HTML

print(load('theme/footer.html'))
