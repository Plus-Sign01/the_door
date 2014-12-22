class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :comment, length: { maximum: 140 }, allow_blank: true
  
end
