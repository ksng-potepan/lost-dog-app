class Amble < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :size, :gender, :date, :prefecture, presence: true
end
