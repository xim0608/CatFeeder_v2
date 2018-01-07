class FeedChannel < ApplicationCable::Channel

  def subscribed
    # stream_from "feed_channel_#{self.current_user.id}"
    stop_all_streams
    stream_from 'all'
    stream_for current_user
    # Rails.logger.info("feed_channel_#{self.current_user.id}")
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    logger.info(data)
    # FeedChannel.broadcast_to(current_user, 'kokekokko-')
  end

  def create_message(data)

  end
end