class LineController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]

  def send_testing
    user = User.find(params[:id])
    raise unless user.present?
    message = {
        type: 'text',
        text: 'hello'
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
                  text: message_processing(event.message['text'] + user.line_user_id)
              }
              client.reply_message(event['replyToken'], message)
            when Line::Bot::Event::MessageType::Image
              response = client.get_message_content(event.message['id'])
              tf = Tempfile.open("content")
              tf.write(response.body)

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

  def message_processing(message)
    case message
      when 'えさをやる'
        return 'えさをやったよ'
      else
        return message
    end
  end

end
