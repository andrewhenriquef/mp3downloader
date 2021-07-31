class DownloadMusicChannel < ApplicationCable::Channel
  def subscribed
    stream_from "download_music_channel_#{params[:uuid]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    youtube_url = data['youtube_url']

    Rails.logger.info("#{params[:uuid]}: Received request to dowload music!: #{youtube_url}")

    file_name, file_path = download_music_from_youtube(youtube_url)

    Rails.logger.info("#{params[:uuid]}: Music file: #{file_name} downloaded locally!")

    music_url = upload_mp3_file_to_aws(file_name, file_path)

    Rails.logger.info("#{params[:uuid]}: Music file: #{file_name} uploaded to aws!")

    ActionCable.server.broadcast(
      "download_music_channel_#{params[:uuid]}",
      music_url: music_url,
      music_name: file_name
    )
  end

  def download_music_from_youtube(youtube_url)
    youtube_dl_wrapper = YoutubeDlWrapper.new(
      youtube_url: youtube_url
    )

    youtube_dl_wrapper.download

    [youtube_dl_wrapper.file_name, youtube_dl_wrapper.file_path]
  end

  def upload_mp3_file_to_aws(file_name, file_path)
    aws_wrapper = AwsClientWrapper.new(
      path_to_file: file_path,
      file_name: file_name
    )

    aws_wrapper.save_file_and_generate_link_to_download!
  end
end
