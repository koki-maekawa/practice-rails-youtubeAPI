module YoutubeApi
    extend ActiveSupport::Concern

    def initialize
        @youtube = Google::Apis::YoutubeV3::YouTubeService.new
        @youtube.key = Rails.application.credentials.youtube[:api_key]
    end

    #
    # Youtube APIで動画を検索し取得
    #
    def search_youtube_videos(query)
        @youtube.list_searches(
            :snippet,
            type: "video",
            q: (query.nil? ? nil : query),
            max_results: 12,
            region_code: "JP",
            # 一つのチャンネルから検索
            channel_id: nil,
            # HD 動画のみ
            video_definition: "high",
            # 埋め込み可能な動画のみを検索
            video_embeddable: true,
            # 関連度が高い順
            order: "relevance",
            # レスポンス内容
            fields: "items(id(video_id), snippet(channel_title,title,thumbnails(medium(url))))"
        )
    end
end
