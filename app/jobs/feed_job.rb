class FeedJob < ApplicationJob
  queue_as :default

  def perform(user)
    # ActionCable.server.broadcast "feed_channel_#{user.id}", {content: 'Feed!!!!!!!!!!'}
    FeedChannel.broadcast_to(user, {content: 'Feed!!!!!!'})
  end
end