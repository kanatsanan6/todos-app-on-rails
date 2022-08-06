# frozen_string_literal: true

class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :companies
  has_many :membership
  has_many :companies, through: :membership

  enum :role, { user: 0, admin: 1, moderator: 2 }
end
