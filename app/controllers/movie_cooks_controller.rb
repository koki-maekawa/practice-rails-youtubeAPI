class MovieCooksController < ApplicationController
  include YoutubeApi
  def index
    if params[:query].present?
        query = params[:query]
    end
    @videos = search_youtube_videos(query)
  end
end
