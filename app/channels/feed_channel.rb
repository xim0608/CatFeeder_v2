class FeedChannel < ApplicationCable::Channel

  def subscribed
    stream_from "feed_channel_#{self.current_user.id}"
    Rails.logger.info('subscribed!')
    Rails.logger.info("feed_channel_#{self.current_user.id}")
  end

  def unsubscribed
  end

  def speak
  end
end