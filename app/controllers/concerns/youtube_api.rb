module YoutubeApi
    extend ActiveSupport::Concern

    def initialize
        @youtube = Google::Apis::YoutubeV3::YouTubeService.new
        @youtube.key = Rails.application.credentials.youtube[:api_key]
        @channel_ids = [
                            "UCW01sMEVYQdhcvkrhbxdBpw", # 料理研究家リュウジ
                            "UCLcqrpFhRlJnm6etuLQblWg", # (賛否両論)笠原
                            "UC3p5OTQsMEnmZktWUkw_Y0A" # 料理研究家コウケンテツ
                        ]
    end

    # Youtube検索結果
    def youtube_videos(query)
        @youtube_videos = []
        @youtube_videos += fetch_youtube_videos_from_channels(query).map do |item|
            {
                video_id: item.id.video_id,
                channel_title: item.snippet.channel_title,
                title: item.snippet.title,
                url: item.snippet.thumbnails.medium.url,
                view_count: fetch_view_count(item)
            }
        end
        #再生回数順にソート
        @youtube_videos.sort_by! { |video| -video[:view_count] }
    end

    private

    # 検索内容のYouTube動画をAPIで取得（指定したチャンネル）
    def fetch_youtube_videos_from_channels(query)
        resutl_youtubes_channels = []
        @channel_ids.each do |channel_id|
            resutl_youtubes_channels += fetch_youtube_videos(query, channel_id)
        end
        resutl_youtubes_channels
    end

    # 検索内容のYoutube動画をAPIで取得
    def fetch_youtube_videos(query = nil, channel_id = nil)
        @youtube.list_searches(
            :snippet,
            type: "video",
            q: query,
            max_results: 5,
            region_code: "JP",
            # 一つのチャンネルから検索
            channel_id: channel_id,
            # HD 動画のみ
            video_definition: "high",
            # 埋め込み可能な動画のみを検索
            video_embeddable: true,
            # 関連度が高い順
            order: "relevance",
            # レスポンス内容
            fields: "items(id(video_id), snippet(channel_title,title,thumbnails(medium(url))))"
        ).items
    end

    # Youtube動画の再生回数を取得
    # - list_searchesメソッドでは再生回数を取得できないためlist_videosを使って取得
    def fetch_view_count(item)
        view_count = @youtube.list_videos(
                        :statistics,
                        id: item.id.video_id,
                        fields: "items(statistics(view_count))"
                        ).items[0].statistics.view_count
    end
end
