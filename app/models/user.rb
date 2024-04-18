class User < ApplicationRecord
  validates :name, :dob, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validate :check_dob

  def check_dob
    unless dob.present? && dob < (Date.today - 18.year)
      errors.add(:dob, 'You are not an adult person')
    end
  end
end
