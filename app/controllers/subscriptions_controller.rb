class SubscriptionsController < ApplicationController

  def create
    @subscriber = Subscriber.find(params[:subscription][:subscriber_id])
    @subscriber.subscriptions.build(magazine_id: params[:subscription][:magazine_id])
    @subscriber.save
    render 'subscriptions/subscribed'
  end

end