class DataAccess
	require 'rubygems'
	gem 'dbi'
	require 'dbi'
	require 'lib/puu'
	require 'lib/init'
	require 'lib/pad_model'
	
	# OnePadで使用するテーブル名の定義
	@@table = Init::MYSQL_TABLENAME
	
	def initialize
		begin
			# MySQLサーバへ接続
			@dbh = DBI.connect(Init::MYSQL_DATASOURCE, Init::MYSQL_USERNAME, Init::MYSQL_PASSWORD)
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
	
	# 指定したOnePadを取得する
	def get_pad(pid)
		sql  = "SELECT * FROM #{@@table} "
		sql += "WHERE pid = ? AND is_deleted = '0' "
		sql += "ORDER BY saved_at DESC "
		sql += "LIMIT 1;"
		sth = @dbh.execute(sql, pid)
		if row = sth.fetch then
			PadModel.new(row)
		else
			raise "データが見つかりません"
		end
	end
	
	# 指定したOnePadを取得する
	def get_pad_with_rev(pid, rev)
		sql  = "SELECT * FROM #{@@table} "
		sql += "WHERE id = ? AND pid = ? AND is_deleted = '0' "
		sql += "ORDER BY saved_at DESC "
		sql += "LIMIT 1;"
		sth = @dbh.execute(sql, rev, pid)
		if row = sth.fetch then
			PadModel.new(row)
		else
			raise "データが見つかりません"
		end
	end
	
	# 指定したOnePadの履歴を取得する
	def get_pad_history(pid)
		sql  = "SELECT id, pid, text, status, host, agent, saved_by, "
		sql += "    DATE_FORMAT(saved_at, '%Y/%m/%d %H:%i:%s') AS saved_at, saved_with, is_deleted "
		sql += "FROM #{@@table} "
		sql += "WHERE pid = ? AND is_deleted = '0' "
		sql += "ORDER BY saved_at DESC "
		sql += "LIMIT 20;"
		sth = @dbh.execute(sql, pid);
		pads = Array.new()
		sth.fetch do |pad|
			pads.push(PadModel.new(pad))
		end
		pads
	end
	
	def manual_save_pad(model)
		sql  = 'INSERT INTO ' + @@table + ' '
		sql += '(pid, text, status, host, agent, saved_with) VALUES (?, ?, ?, ?, ?, ?);'
		@dbh.do(sql, model.pid, model.text, 'M', model.host, model.agent, model.saved_with);
	end

	def auto_save_pad(model)
		sql  = 'INSERT INTO ' + @@table + ' '
		sql += '(pid, text, status, host, agent, saved_with) VALUES (?, ?, ?, ?, ?, ?);'
		@dbh.do(sql, model.pid, model.text, 'A', model.host, model.agent, model.saved_with);
	end
end

