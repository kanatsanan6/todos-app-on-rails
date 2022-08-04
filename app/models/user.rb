# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :assign_default_role

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
end
