class String
  # ランダムな文字列を生成する
  # @param [Fixnum] length 桁数
  # @retrun [String] ランダムな文字列
  def self.password(length = 16)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    Array.new(length){ chars[rand(chars.size)] }.join
  end

  # 文字列から true / false を返す
  # @return 'true' の場合 true 、 'false' の場合 false 、 左記以外の場合 nil
  def to_b
    case self
      when 'true' then
        true
      when 'false' then
        false
      else
        nil
    end
  end
end
