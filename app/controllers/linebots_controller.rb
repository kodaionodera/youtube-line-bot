# frozen_string_literal: true

class LinebotsController < ApplicationController
  require 'line/bot'
  # require 'dotenv'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  # TODO: bolumeできてない
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, { 'Content-Type' => 'text/plain' }, 'Bad Request'
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    'OK'
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
