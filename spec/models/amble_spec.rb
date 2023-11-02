require 'rails_helper'

RSpec.describe Amble do
  let(:user)  { create(:user) }
  let(:amble) { create(:amble, user:) }

  describe "バリデーションのテスト" do
    it "date、prefecture、name、gender、sizeがあれば有効な状態であること" do
      expect(amble).to be_valid
    end

    it "featuresが50文字以下でなければ無効であること" do
      amble.features = "a" * 51
      amble.valid?
      expect(amble.errors[:features]).to include("は50文字以内で入力してください")
    end

    it "situationが50文字以下でなければ無効であること" do
      amble.situation = "a" * 51
      amble.valid?
      expect(amble.errors[:situation]).to include("は50文字以内で入力してください")
    end
  end

  describe "date_before_start" do
    it "日付がなければ無効であること" do
      amble = described_class.new(date: nil)
      amble.valid?
      expect(amble.errors[:date]).to include("を入力してください")
    end

    it "日付が今日より前でないと無効であること" do
      amble = described_class.new(date: Date.current + 1)
      amble.valid?
      expect(amble.errors[:date]).to include("は今日を含む前の日付を登録してください。")
    end

    it "日付が今日より前であれば有効であること" do
      amble = described_class.new(date: Date.current - 1)
      amble.valid?
      expect(amble.errors[:date]).to be_empty
    end
  end
end
