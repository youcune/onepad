class DataAccess
	require 'rubygems'
	gem 'dbi'
	require 'dbi'
	require 'lib/puu'
	require 'lib/pad_model'
	
	# OnePadで使用するテーブル名の定義
	@@table = 'onepad_pads'
	
	def initialize
		begin
			# MySQLサーバへ接続
			@dbh = DBI.connect("dbi:Mysql:anone_apps:localhost", "anone_apps", "sWKw7GK^3^TY")
		rescue DBI::DatabaseError => e
			abort("#{e.err}: #{e.errstr}")
		end
	end
	
	def create_new_pad(host, agent)
		sql = 'INSERT INTO ' + @@table + ' (pid, text, host, agent) VALUES (?, ?, ?, ?);'
		text  = '【あなたのOnePadが作成されました！】' + "\n"
		text += 'ここにメモの本文を入力します。' + "\n"
		text += 'このURLにアクセスすると、いつでもあなたのOnePadを表示、編集できます。' + "\n"
		text += 'ブラウザやスマートフォンでブックマークして活用しよう！'
		pid = make_password(10)
		@dbh.do(sql, pid, text, host, agent)
		pid
	end
	
	def get_pad(pid)
		sql  = 'SELECT * FROM ' + @@table + ' '
		sql += 'WHERE pid = ? AND is_deleted = \'0\' '
		sql += 'ORDER BY saved_at DESC '
		sql += 'LIMIT 1;'
		sth = @dbh.execute(sql, pid);
		PadModel.new(sth.fetch);
	end

	def manual_save_pad(model)
		sql  = 'INSERT INTO ' + @@table + ' '
		sql += '(pid, text, status, host, agent, saved_with) VALUES (?, ?, ?, ?, ?, ?);'
		@dbh.do(sql, model.pid, model.text, 'M', model.host, model.agent, model.saved_with);
	end

	def manual_save_pad(model)
		sql  = 'INSERT INTO ' + @@table + ' '
		sql += '(pid, text, status, host, agent, saved_with) VALUES (?, ?, ?, ?, ?, ?);'
		@dbh.do(sql, model.pid, model.text, 'A', model.host, model.agent, model.saved_with);
	end
end