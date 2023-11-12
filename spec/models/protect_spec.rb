require 'rails_helper'

RSpec.describe Protect do
  let(:user) { create(:user) }
  let(:protect) { create(:protect, user:) }

  describe "バリデーションのテスト" do
    it "date、prefecture、situation、gender、sizeがあれば有効な状態であること" do
      expect(protect).to be_valid
    end

    it "featuresが50文字以下でなければ無効であること" do
      protect.features = "a" * 51
      protect.valid?
      expect(protect.errors[:features]).to include("は50文字以内で入力してください")
    end

    it "situationが50文字以下でなければ無効であること" do
      protect.situation = "a" * 51
      protect.valid?
      expect(protect.errors[:situation]).to include("は50文字以内で入力してください")
    end
  end

  describe "date_before_start" do
    it "日付がなければ無効であること" do
      protect = described_class.new(date: nil)
      protect.valid?
      expect(protect.errors[:date]).to include("を入力してください")
    end

    it "日付が今日より前でないと無効であること" do
      protect = described_class.new(date: Date.current + 1)
      protect.valid?
      expect(protect.errors[:date]).to include("は今日を含む前の日付を登録してください。")
    end

    it "日付が今日より前であれば有効であること" do
      protect = described_class.new(date: Date.current - 1)
      protect.valid?
      expect(protect.errors[:date]).to be_empty
    end
  end
end
