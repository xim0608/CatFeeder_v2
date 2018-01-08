CarrierWave.configure do |config|
  if Rails.env.development?
    config.asset_host = 'http://localhost:3000'
  else
    config.asset_host = ENV['APPLICATION_URL']
  end
  config.cache_dir = "#{Rails.root}/tmp/uploads"

end
