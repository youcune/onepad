#!/usr/bin/ruby -Ku

# OnePad
# edit.cgi v0.1

require 'lib/data_access'

puts('Content-type: text/html; charset=UTF-8')
puts()
print(load('theme/header.html'))

da = DataAccess.new
model = da.get_pad(p_textbox('pid'))

print <<"END_OF_HTML"
<form id="form">
	<textarea name="text" id="text" wrap="soft" onkeyup="update_count();">#{model.text}</textarea>
</form>
<div id="footer">
	<div id="count"></div>
	<div>
		<button id="save" onclick="update_pad('#{model.pid}'); return(false);">SAVE</button>
	</div>
</div>
END_OF_HTML
print(load('theme/footer.html'))
