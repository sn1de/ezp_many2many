class Magazine < ActiveRecord::Base
  attr_accessible :description, :editor, :title
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions
end
