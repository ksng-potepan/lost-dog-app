require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#full_title' do
    it '引数がnilの時に動的な表示がされること' do
      expect(full_title(nil)).to eq('ドッグル')
    end

    it '引数が渡されている時に動的な表示がされること' do
      expect(full_title('sample')).to eq('sample / ドッグル')
    end

    it '引数が空文字の時に動的な表示がされること' do
      expect(full_title('')).to eq('ドッグル')
    end
  end
end
