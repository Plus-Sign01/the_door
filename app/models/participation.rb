class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  validates :school, presence: true
  validates :language, presence: true
  validates :skill, presence: true


  validates :comment, length: { maximum: 140 }, allow_blank: true

end
