Rails Many to Many Example
==========================

Create the Rails Application
----------------------------

rails new publisher

cd publisher

rake db:create

rails s

Setup our Magazine and Subscriber Entities
------------------------------------------

There are two entites that we will create using scaffolding. The scaffold generation will create a model and the associated controllers and views necessary to create and display records.

rails generate scaffold Magazine title:string description:text editor:string

rails generate scaffold Subscriber name:string address:text

rake db:migrate

Create our Association Model
----------------------------

Since we are not going to be doing CRUD operations directly against the subscription model (i.e. we wouldn't want to see a form with just a subscriber id field and a magazine id field and have to put the raw id numbers into that to create a subscription) there is no need for all of the functionality scaffolding creates. We will just generate the model with the necessary id fields for the subscriber and the magazine, plus a few additional details to help us manage the lifecycle of the subscription.

rails generate model Subscription subscriber_id:integer magazine_id:integer start:date duration:integer

rake db:migrate

Implement the Many to Many Relationship
---------------------------------------

We need to now 'tell' our original Magazine and Subscriber models about the model that is going to provide their many to many relationship.

	class Magazine < ActiveRecord::Base
	  attr_accessible :description, :editor, :title
	  has_many :subscriptions
	  has_many :subscribers, through: :subscriptions
	end

	class Subscriber < ActiveRecord::Base
	  attr_accessible :address, :name
	  has_many :subscriptions
	  has_many :magazines, through: :subscriptions
	end

	class Subscription < ActiveRecord::Base
	  attr_accessible :duration, :magazine_id, :start, :subscriber_id
	  belongs_to :magazine
	  belongs_to :subscriber
	end
