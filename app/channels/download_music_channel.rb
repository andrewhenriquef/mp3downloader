class DownloadMusicChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "download_music_channel_#{params[:uuid]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
