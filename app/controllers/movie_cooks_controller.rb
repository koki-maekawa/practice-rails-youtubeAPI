class MovieCooksController < ApplicationController
  include YoutubeApi
  def index
    if params[:query].present?
        query = params[:query]
    end
    @videos = youtube_videos(query)
  end
end
