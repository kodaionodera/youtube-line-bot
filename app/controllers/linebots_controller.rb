# frozen_string_literal: true

class LinebotsController < ApplicationController
  require 'line/bot'
  require 'dotenv'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  # TODO: bolumeできてない
  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
          puts '¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥'
          puts event
          puts evnet.type
          puts event.type.class
          puts '¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥'
        when Line::Bot::Event::MessageType::Text
          if keyword.present?
            message = {
              type: 'text',
              text: event.message['text']
            }
          else
            message = {
              type: 'text',
              text: 'テキストを入力してください'
            }
          end
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def select_word
    # この中を変えると返ってくるキーワードが変わる
    seeds = %w[アイデア１ アイデア２ アイデア３ アイデア４]
    seeds.sample
  end
end
