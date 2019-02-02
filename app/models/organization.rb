# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :ownerships, as: :ownable
  has_many :created_courses, through: :ownerships, source: :course

  validates :name, presence: true, length: { in: 2..20 }
  validates :description, length: { maximum: 500 }
end
