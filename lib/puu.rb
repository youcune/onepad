# pear's Universal Utilities
# puu.rb

require 'cgi'
require 'socket'

@@puu_cgi = CGI.new

# ------------------------------------------------------------------ #
# 汎用メソッド
# ------------------------------------------------------------------ #
def make_password(length = 16)
	a = ('a'..'k').to_a + ('m'..'z').to_a + ('A'..'H').to_a + ('J'..'N').to_a + ('P'..'Z').to_a + ('2'..'9').to_a
	(
		Array.new(length) do
			a[rand(a.size)]
		end
	).join
end

def load(fname)
	f = open(fname)
	str = f.read
	f.close
	str
end

# ------------------------------------------------------------------ #
# CGIメソッド
# ------------------------------------------------------------------ #
def gethostbyaddr(addr)
	a = Socket.gethostbyname(addr)
	Socket.gethostbyaddr(a[3], a[2]).first
end

def get_terminal(agent)
	agent =~ /iPhone/ ? 'iPhone' :
	agent =~ /iPad/ ? 'iPad' :
	agent =~ /Android/ ? 'Android' :
	agent =~ /Windows Phone/ ? 'Windows Phone' :
	agent =~ /Windows/ ? 'Windows' :
	agent =~ /Mac OS X/ ? 'Mac' : nil
end

# ------------------------------------------------------------------ #
# パラメータメソッド
# ------------------------------------------------------------------ #
# そのまま
def param(key)
	@@puu_cgi[key]
end

# HTML出力用文字列（1行）
def p_textbox(key)
	if @@puu_cgi[key].nil? then
		nil
	else
		@@puu_cgi[key].escape.flatten
	end
end

# HTML出力用文字列（複数行）
def p_textarea(key)
	if @@puu_cgi[key].nil? then
		nil
	else
		@@puu_cgi[key].escape
	end
end

# Integerとして
def p_integer(key)
	if @@puu_cgi[key].nil? then
		0
	else
		@@puu_cgi[key].to_i
	end
end

# ------------------------------------------------------------------ #
# 組み込みクラス拡張メソッド
# ------------------------------------------------------------------ #
class String
	def escape
		# 特殊記号をHTMLにする（非破壊的）
		str = self
		str.escape!
		str
	end
	
	def escape!
		# 特殊記号をHTMLにする（破壊的）
		self.gsub!('<', '&lt;')
		self.gsub!('>', '&gt;')
		self.gsub!('"', '&quot;')
	end
	
	def flatten
		# 改行をなくす（非破壊的）
		str = self
		str.flatten!
		str
	end
	
	def flatten!
		# 改行をなくす（破壊的）
		self.gsub!("\r\n", ' ')
		self.gsub!("\n", ' ')
		self.gsub!("\r", ' ')
	end
end
