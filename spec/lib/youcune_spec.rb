require 'spec_helper'

describe 'youcune.rb' do
  describe 'String#password' do
    it 'should return password with 16 chars' do
      expect(String.password.length).to eq(16)
    end

    it 'should return password with specific chars' do
      expect(String.password(12).length).to eq(12)
    end
  end
end
