class Subscriber < ActiveRecord::Base
  attr_accessible :address, :name
  has_many :subscriptions
  has_many :magazines, through: :subscriptions
end
