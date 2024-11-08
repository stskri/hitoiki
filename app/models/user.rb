class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image
  has_many :post, dependent: :destroy
  has_many :post_comment, dependent: :destroy
  has_many :favorite, dependent: :destroy
  has_many :inquiry, dependent: :destroy
  has_many :entry, dependent: :destroy
  has_many :room, dependent: :destroy
  has_many :message, dependent: :destroy
end
