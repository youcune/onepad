require 'spec_helper'

describe Pad do
  fixtures :pads

  describe '#find_latest' do
    it 'should return latest pad' do
      pad = Pad.find_latest('pad1')
      expect(pad.id).to eq(4)
    end

    it 'should return latest pad except for autosaved one' do
      pad = Pad.find_latest('pad2')
      expect(pad.id).to eq(2)
    end
  end

  describe '#find_one' do
    it 'should return specified pad' do
      pad = Pad.find_one('pad1', '2013-0101-0000')
      expect(pad.id).to eq(1)
    end
  end

  describe '#find_all' do
    it 'should return all pads' do
      pads = Pad.find_all('pad1')
      expect(pads.count).to eq(3)
    end

    it 'should order latest first' do
      pads = Pad.find_all('pad1')
      expect(pads.first.revision).to eq('2013-0101-0501')
      expect(pads.last .revision).to eq('2013-0101-0000')
    end
  end

  describe '#save' do
    it 'should create new record' do
      result = Pad.save('pad2', '初夢の内容', false)
      pads = Pad.find_all('pad2')
      expect(result).to be_true
      expect(pads.count).to eq(3)
      expect(pads.first.content).to eq('初夢の内容')
    end

    it 'should update record when same revision already exists' do
      # TODO
    end
  end

  # TODO auto-generated
  describe '#save!' do
    # TODO
  end
end
