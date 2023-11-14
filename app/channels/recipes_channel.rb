class RecipesChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(params[:user_id])
    stream_from 'recipes_channel' if user

  rescue ActiveRecord::RecordNotFound => e
    reject
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
