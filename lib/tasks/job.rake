namespace :job do
  desc "TODO"
  task feed: :environment do
    user = User.find(1)
    FeedChannel.broadcast_to(user, 'kokekokko-')
  end

  task feed_all: :environment do
    ActionCable.server.broadcast 'all', {'message': 'hello'}
  end

end
