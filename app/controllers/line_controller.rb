class LineController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback, :send_photo]

  def send_notice
    uuid = request.headers['HTTP_ACCESS_TOKEN_UUID']
    user = User.find_by(client_uuid: uuid)
    logger.info(user)
    raise unless user.present?
    message = {
        type: 'text',
        text: 'hello'
    }
    client.push_message(user.line_user_id, message)
    render json: {'status': 'success'}
  end

  def send_photo
    uuid = request.headers['HTTP_ACCESS_TOKEN_UUID']
    user = User.find_by(client_uuid: uuid)
    logger.info(user)
    # logger.info(params[:media].tempfile.read)
    # TODO: save image and send url
    raise unless user.present?
    message = {
        type: 'image',
        originalContentUrl: 'hello',
        previewImageUrl: 'hello'
    }
    client.push_message(user.line_user_id, message)
    render json: {'status': 'success'}
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do
        'Bad Request'
      end
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
        when Line::Bot::Event::Message
          user = User.find_or_create_by(line_user_id: event['source']['userId'])
          case event.type
            when Line::Bot::Event::MessageType::Text
              message = {
                  type: 'text',
                  text: message_processing(event.message['text'], user)
              }
              client.reply_message(event['replyToken'], message)
            when Line::Bot::Event::MessageType::Image
              response = client.get_message_content(event.message['id'])
            # tf = Tempfile.open("content")
            # tf.write(response.body)
            # file_name = "#{Rails.root}/tmp/#{SecureRandom.uuid}.jpg"
            # file = File.open(file_name, "w+b")
            # file.write(response.body)
          end
      end
    end
    "OK"
  end

  private

  def client
    @client ||= Line::Bot::Client.new {|config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def message_processing(message, user)
    case message
      when 'えさをやる'
        FeedChannel.broadcast_to(user, 'Feed!!!!')
        return 'えさをやったよ'
      else
        if is_uuid?(message)
          logger.info("is uuid ! #{message}")
          if user.client_uuid.present?
            msg = '古いラズパイの情報を上書きし、再登録しました'
          else
            msg = 'ラズパイと連携しました'
          end
          user.client_uuid = message
          user.save!
          return msg
        end
        return 'はい？'
    end
  end

  def is_uuid?(uuid)
    return false unless uuid.length == 36
    v = uuid =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    if v == 0
      logger.info("is uuid ! #{uuid}")
      true
    else
      logger.info("not uuid ! #{uuid}")
      false
    end
  end

end
