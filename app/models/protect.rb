class Protect < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :date, :size, :gender, :situation, :municipalities, presence: true
  validates :features, :situation, length: { maximum: 50 }
  validates :prefecture, exclusion: { in: ['都道府県'] }
  validate :date_before_start

  def date_before_start
    if date.nil?
      errors.add(:date, "を入力してください")
    else
      errors.add(:date, "は今日を含む前の日付を登録してください。") unless
      date <= Date.current
    end
  end
end
