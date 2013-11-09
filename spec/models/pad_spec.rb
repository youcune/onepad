require 'spec_helper'

describe Pad do
  fixtures :pads

  describe '#find_latest' do
    it 'should return latest pad' do
      pad = Pad.find_latest('pad1')
      expect(pad.id).to eq 4
    end

    it 'should return latest pad except for autosaved one' do
      pad = Pad.find_latest('pad2')
      expect(pad.id).to eq 2
    end
  end

  describe '#find_one' do
    it 'should return specified pad' do
      pad = Pad.find_one('pad1', '2013-0101-0000')
      expect(pad.id).to eq 1
    end
  end

  describe '#find_all' do
    it 'should return all pads' do
      pads = Pad.find_all 'pad1'
      expect(pads.count).to eq 3
    end

    it 'should order latest first' do
      pads = Pad.find_all('pad1')
      expect(pads.first.revision).to eq '2013-0101-0501'
      expect(pads.last .revision).to eq '2013-0101-0000'
    end
  end

  describe '#save' do
    it 'should create new pad' do
      saved = Pad.new(content: 'Hello, World!')
      saved.save!

      loaded = Pad.find_latest(saved.key)
      expect(loaded.content).to eq saved.content
    end

    it 'should create new record' do
      saved = Pad.new(key: 'pad1', content: 'Hello, World!')
      saved.save!

      loaded = Pad.find_latest('pad1')
      expect(loaded.id).to be > 5
      expect(loaded.content).to eq saved.content
    end
  end

  describe '#generate_key' do
    it 'should generate key' do
      result = Pad.__send__(:generate_key)
      expect(result).to match /\A[a-z]{4}-[a-z]{4}\Z/
      p result
    end
  end
end
