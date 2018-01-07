module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.info('connected by user' + self.current_user.line_user_id)
    end

    protected
    def find_verified_user
      if verified_user = User.find_by(client_uuid: request.params[:uuid])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
