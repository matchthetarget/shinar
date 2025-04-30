# To deliver this notification:
#
# NewMessageNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewMessageNotifier < ApplicationNotifier
  required_param :chat

  deliver_by :ios do |config|
    config.device_tokens = -> {
      recipient.notification_tokens.where(platform: :iOS).pluck(:token)
    }
    config.format = ->(apn) {
      apn.alert = "Someone replied to in your chat!"
      apn.custom_payload = {
        path: chat_path(params[:chat])
      }
    }

    credentials = Rails.application.credentials.ios
    config.bundle_identifier = credentials.bundle_identifier
    config.key_id = credentials.key_id
    config.team_id = credentials.team_id
    config.apns_key = credentials.apns_key
    config.development = Rails.env.local?
  end

  deliver_by :fcm do |config|
    config.credentials = Rails.application.credentials.fcm.to_h
  
    config.device_tokens = -> {
      recipient.notification_tokens.where(platform: :FCM).pluck(:token)
    }

    config.json = ->(device_token) {
      {
        message: {
          token: device_token,
          notification: {
            title: "Someone replied in your chat!"
          },
          data: {
            path: chat_path(params[:chat])
          }
        }
      }
    }
  end
end
