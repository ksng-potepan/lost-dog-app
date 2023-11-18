class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true
  has_one_attached :image
  has_many :ambles, dependent: :destroy
  has_many :protecs, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
end
