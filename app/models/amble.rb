class Amble < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :size, :gender, :date, :municipalities, presence: true
  validates :features, :situation, length: { maximum: 50 }
  validate :date_before_start
  validate :prefecture_cannot_be_zero

  def date_before_start
    if date.nil?
      errors.add(:date, "を入力してください")
    else
      errors.add(:date, "は今日を含む前の日付を登録してください。") unless
      date <= Date.current
    end
  end

  def prefecture_cannot_be_zero
    errors.add(:prefecture, "選択してください") if prefecture == 0
  end
end
