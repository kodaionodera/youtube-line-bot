# frozen_string_literal: true

require 'dotenv'
require 'google/apis/youtube_v3'
require 'active_support/all'

class YoutubesController < ApplicationController
  def find_videos(keyword, after: 9.months.ago, before: Time.now) # 検索キーワードと検索範囲を変えれるように引数に値を取っています
    # Dotenv.load ".env"
    # GOOGLE_API_KEY=ENV['API_KEY']

    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = 'AIzaSyC1n4Gh4Y_RNyXq3oTAIZLg_f5-pWuQfYg'
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
    results.items.each do |item|
      id = item.id
      snippet = item.snippet
      puts "\"#{snippet.title}\" by #{snippet.channel_title} (id: #{id.video_id}) (#{snippet.published_at})"
    end
  end

  def index
    @youtube_data = find_videos('ガードマンチャンネル')
  end
end
