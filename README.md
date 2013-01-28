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

Creating Subscriptions
----------------------

Now that we have the data model and the relationships established, the application functionality to allow a Subscriber to 'sign up' for a magazine can now be written. There are a lot of different ways this could be implemented from a UI perspective. We're going to choose to implement a 'Subscribe' link on our Subscriber list. That link will go to a page with all of our magazine publications listed. Next to each of those magazines will be a 'Subscribe' button. Clicking on that button will submit the form post that will in turn write the new subscription record into the database.

Subscription List Page
----------------------

This page is going to be kind of a pick list for magazine subscription. Since our list is already going to be 'pre-loaded' with our subscriber information, it makes sense to use our SubscribersController to build that page. The first step is to establish a URL in our routes.rb file:

	 match 'subscriber/:id/subscription_list' => 'subscribers#subscription_list', :as => :subscription_list

Remember, you can always use 'rake routes' to see list all of the routing in your application.


Then create the controller method in SubscribersController to handle the request by fetching the appropriate subscriber entity and also a list of magazines for potential subscription:

	def subscription_list
	  @subscriber = Subscriber.find(params[:id])
	  @magazines = Magazine.find(:all)
	end

And now the view to render the page. Notice that we've embedded the form to create the subscription in the list and we'll create the routes and application logic for that a little later:

	<h1>Subscribing <%= @subscriber.name %></h1>
	<h2>Magazine Choices</h2>
	<ul>
	<% @magazines.each do |magazine| %>
		<li>
			<%= magazine.title %>
			<%= form_for(@subscriber.subscriptions.build(magazine_id: magazine.id)) do |f|%>
				<%= f.hidden_field :subscriber_id %>		
				<%= f.hidden_field :magazine_id %>
				<%= f.submit "Subscribe" %>
			<% end %>
		</li>
	<% end %>
	</ul>

Subscribe Link
--------------

Now tie the new page into your subscriber view. Add the following code to the app/views/subscribers/index.html.erb file:

	<td><%= link_to 'Subscribe', subscription_list_url(subscriber) %></td>

Making the Subscription Happen
------------------------------

Our form is a little sneaky, in that it is being masked as a simple button. The actual details about who to subscribe to what will be carried in hidden fields. We'll need a route and a handler in the controller, and a confirmation page:

	resources :subscriptions, only: [:create, :destroy]

Note that this route looks nothing like the previous one. It is similar in form to the ones that rails set up for us automatically.

We need to setup a whole new controller class for handling subscriptions /app/controllers/subscriptions_controller.rb:

	class SubscriptionsController < ApplicationController

	  def create
	    @subscriber = Subscriber.find(params[:subscription][:subscriber_id])
	    @subscriber.subscriptions.build(magazine_id: params[:subscription][:magazine_id])
	    @subscriber.save
	    render 'subscriptions/subscribed'
	  end

	end

Our humble confirmation page with a link back to the subscribers detail page /app/views/subscriptions/subscribed.html.erb:

	<h2>Congrats  <%= link_to @subscriber.name, @subscriber %> subscription was successful!</h2>

And ... your done!

Discussion
----------

We used generators and scaffolding when possible in this example. How did that compare with the tutorial approach? What are the pros and cons of using scaffolding? How can scaffolding help you keep up with the evolution of the rails framework?

We had to 'tell' our app about the entity relationships. Why isn't that automatic, like so many other things in rails?

What were the factors used to determine where controller logic resides? Did we need to create a Subscriptions controller, or is there an alternative?

Routing is an often overlooked aspect of creating a rails application. Why? Take a look at the routes file and discuss the evolution of routing in the rails framework.

We requested that a destroy route be created, but we haven't implemented it. What would that take?


