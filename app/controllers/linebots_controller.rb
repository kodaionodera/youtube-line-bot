# frozen_string_literal: true

class LinebotsController < ApplicationController
  # linebot用
  require 'line/bot'
  # youtube用
  require 'google/apis/youtube_v3'
  require 'active_support/all'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless client.validate_signature(body, signature)
      halt 400, { 'Content-Type' => 'text/plain' }, 'Bad Request'
    end

    events = client.parse_events_from(body)
    events.each do |event|
      # 定数は下記参照
      # https://github.com/line/line-bot-sdk-ruby/blob/8963a4c277259b225a766269e9e53040e414b90f/lib/line/bot/event/message.rb#L18
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          item_ids = find_videos(event.message['text'])
          start_word = {
            type: 'text',
            text: "「#{event.message['text']}」という検索ワードにヒットした動画#{item_ids.count}が件ありました！"
          }
          message = item_ids.map do |id|
            {
              type: 'text',
              text: "https://www.youtube.com/embed/#{id.video_id}"
            }
          end

          # 破壊的
          message.unshift(start_word)

        # TODO　全部elseでいいかも
        when Line::Bot::Event::MessageType::Image
          message = {
            type: 'text',
            text: '画像は送れません'
          }
        when Line::Bot::Event::MessageType::Sticker
          message = {
            type: 'text',
            text: 'スタンプは対応していません'
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

    'OK'
  end

  private

  # 今は一番最新のものを取っている
  # 検索キーワードと検索範囲を変えれるように引数に値を取っています
  def find_videos(keyword, after: 9.months.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['API_KEY']
    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 2,
      order: :date,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    results = service.list_searches(:snippet, opt)

    # 動画のidを配列で返却
    results.items.map(&:id)
  end

  # 呼ばれる度にインスタンスを生成しないようにメモ化
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
