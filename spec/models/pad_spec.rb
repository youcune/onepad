require 'spec_helper'

describe Pad do
  fixtures :pads

  describe '#html' do
    it 'はcontentが#から始まる場合はMarkdownとして解釈して返す' do
      pad = Pad.new(content: '# h1')
      expected = '<h1>h1</h1>'
      actual = pad.html.chomp
      expect(actual).to eq expected
    end

    it 'はcontentは#から始まらない場合はHTMLとして返す' do
      pad = Pad.new(content: 'p')
      expected = '<p>p</p>'
      actual = pad.html.chomp
      expect(actual).to eq expected
    end
  end

  describe '#save' do
    it 'はキーが渡されない場合、新しいPadを作成する' do
      pad = Pad.new(content: 'Hello, World!')
      pad.smarter_save
      loaded = Pad.find_latest(pad.key)
      expect(loaded.content).to eq pad.content
    end

    it 'はキーが渡された場合、新しいレコードを作成する' do
      pad = Pad.new(key: 'test-pad1', content: 'Hello, World!')
      pad.smarter_save
      loaded = Pad.find_latest('test-pad1')
      expect(loaded.id).to be > 5
      expect(loaded.content).to eq pad.content
    end

    it 'はキーとリビジョンの組み合わせが存在した場合、既存のレコードを上書きする' do
      expected = 'This pad will overwrite already existing one!'
      pad = Pad.new(key: 'test-pad2', revision: '2013-0101-0000', content: expected, is_autosaved: false)
      expect(pad.smarter_save).to be_truthy
      actual = Pad.find(2)
      expect(actual.content).to eq expected
    end

    it 'はキーとリビジョンの組み合わせが存在した場合、手動保存されたものを自動保存で上書きはしない' do
      dummy = 'This pad will overwrite already existing one!'
      pad = Pad.new(key: 'test-pad2', revision: '2013-0101-0000', content: dummy, is_autosaved: true)
      expect(pad.smarter_save).to be_truthy
      actual = Pad.find(2)
      expect(actual.content).to eq 'あけました'
    end

    it 'は同じ時刻に一定数のレコードが存在する場合には新しいPadを作らない' do
      Pad::LIMIT_PER_MINUTE.times do
        Pad.new(revision: '2013-1215-1600', content: 'Hello, World!').smarter_save
      end
      pad = Pad.new(revision: '2013-1215-1600', content: 'This pad cannot be saved!')
      expect{ pad.smarter_save }.to raise_error(RetryableError)
    end

    it 'はcontent内の危険そうな文字を安全に変換する' do
      pad = Pad.new(content: '<script>alert("DANGER!");</script>')
      pad.smarter_save
      loaded = Pad.find_latest(pad.key)
      expected = '&lt;script&gt;alert(&quot;DANGER!&quot;);&lt;/script&gt;'
      expect(loaded.content).to eq expected
    end
  end

  describe '#find_latest' do
    it 'は最新のPadを返す' do
      pad = Pad.find_latest('test-pad1')
      expect(pad.id).to eq 4
    end

    it 'は最新のPadを返すが、自動保存されたものは除外する' do
      pad = Pad.find_latest('test-pad2')
      expect(pad.id).to eq 2
    end

    it 'は指定したkeyでPadが見つからない場合、nilを返す' do
      pad = Pad.find_latest('missing_key')
      expect(pad).to be_nil
    end
  end

  describe '#find_one' do
    it 'はkeyとrevisionを指定して1件のPadを返す' do
      pad = Pad.find_one('test-pad1', '2013-0101-0000')
      expect(pad.id).to eq 1
    end

    it 'は指定したkeyとrevisionでPadが見つからない場合、nilを返す' do
      pad = Pad.find_one('test-pad1', '9999-9999-9999')
      expect(pad).to be_nil
    end
  end

  describe '#find_all' do
    it 'は新しいものから順にすべてのPadを返す' do
      pads = Pad.find_all('test-pad1')
      expect(pads.count).to eq 3
      expect(pads.first.revision).to eq '2013-0101-0501'
      expect(pads.last .revision).to eq '2013-0101-0000'
    end
  end

  describe '#generate_key' do
    it 'は ????-???? の形式で文字列を返す' do
      result = Pad.generate_key
      expect(result).to match /\A[a-z]{4}-[a-z]{4}\Z/
    end
  end

  describe '#parse_as_html' do
    it 'は改行を<br>にして全体を<p>で囲んで返す' do
      source = 'Hello
World'
      expected = '<p>Hello<br>World</p>'
      actual = Pad.parse_as_html(source)
      expect(actual).to eq expected
    end

    it 'はURLをリンクに変換して返す' do
      source = 'http://example.com/something-to-link
https://example.com/something-to-link'
      expected = '<p><a href="http://example.com/something-to-link">http://example.com/something-to-link</a><br><a href="https://example.com/something-to-link">https://example.com/something-to-link</a></p>'
      actual = Pad.parse_as_html(source)
      expect(actual).to eq expected
    end

    it 'は電話番号らしきものをリンクに変換して返す' do
      source = '080-0000-0000'
      expected = '<p><a href="tel:080-0000-0000">080-0000-0000</a></p>'
      actual = Pad.parse_as_html(source)
      expect(actual).to eq expected
    end

    it 'は電子メールアドレスらしきものをリンクに変換して返す' do
      source = 'i+some-alias@youcune.com'
      expected = '<p><a href="mailto:i+some-alias@youcune.com">i+some-alias@youcune.com</a></p>'
      actual = Pad.parse_as_html(source)
      expect(actual).to eq expected
    end
  end
end
