require 'rails_helper'

RSpec.describe Sighting do
  let(:user) { create(:user) }
  let(:sighting) { create(:sighting, user:) }

  describe "バリデーションのテスト" do
    it "areaがあれば有効な状態であること" do
      expect(sighting).to be_valid
    end

    it "latの入力値が文字列の場合無効であること" do
      sighting.lat = "ハチ公"
      sighting.valid?
      expect(sighting.errors[:lat]).to include("マーカーを立ててください")
    end

    it "latの入力値が0の場合無効であること" do
      sighting.lat = 0
      sighting.valid?
      expect(sighting.errors[:lat]).to include("マーカーを立ててください")
    end

    it "situationが100文字以下でなければ無効であること" do
      sighting.situation = "a" * 101
      sighting.valid?
      expect(sighting.errors[:situation]).to include("は100文字以内で入力してください")
    end
  end

  describe "date_before_start" do
    it "日付がなければ無効であること" do
      sighting = described_class.new(date: nil)
      sighting.valid?
      expect(sighting.errors[:date]).to include("を入力してください")
    end

    it "日付が今日より前でないと無効であること" do
      sighting = described_class.new(date: Date.current + 1)
      sighting.valid?
      expect(sighting.errors[:date]).to include("は今日を含む前の日付を登録してください。")
    end

    it "日付が今日より前であれば有効であること" do
      sighting = described_class.new(date: Date.current - 1)
      sighting.valid?
      expect(sighting.errors[:date]).to be_empty
    end
  end
end
