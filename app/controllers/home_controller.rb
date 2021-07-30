class HomeController < ApplicationController
  def index; end

  def download
    service = YoutubeDlWrapperService.new(
      youtube_url: allowed_parameters[:youtube_url]
    )

    service.download

    file_name = service.file_name
    file_path = service.file_path

    File.open(file_path) do |music_file|
      ActionCable.server.broadcast(
        "download_music_channel_#{uuid}",
        music: music_file,
        file_name: file_name,
        content_type: 'audio/mpeg'
      )
    end
  end

  private

  def allowed_parameters
    params.permit(:youtube_url)
  end
end
