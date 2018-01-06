class FeedChannel < ApplicationCable::Channel

  def subscribed
    stream_from 'feed_channel'
    Rails.logger.info('subscribed!')
  end

  def unsubscribed
  end

  def speak
  end
end