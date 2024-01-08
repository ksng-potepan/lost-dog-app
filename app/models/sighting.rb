class Sighting < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :lat, numericality: { greater_than: 0 }
  validates :area, presence: true
  validates :situation, length: { maximum: 100 }
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
