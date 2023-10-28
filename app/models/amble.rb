class Amble < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :date, :prefecture, presence: true
end
