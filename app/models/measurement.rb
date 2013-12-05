class Measurement < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :weight, presence: true
  validates :taken_at, presence: true
end
