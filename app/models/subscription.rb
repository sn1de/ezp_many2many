class Subscription < ActiveRecord::Base
  attr_accessible :duration, :magazine_id, :start, :subscriber_id
  belongs_to :magazine
  belongs_to :subscriber
end
