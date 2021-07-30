class YoutubeDlWrapperService
  MUSICS_PATH = Rails.root.join('tmp', 'musics').to_s.freeze

  def initialize(youtube_url:)
    @youtube_url = youtube_url
  end

  def download
    download_mp3!
    file_path
  end

  def download_mp3!
    `youtube-dl #{audio_configurations} #{output} #{youtube_url}`
  end

  def file_name
    @file_name ||= `youtube-dl --get-title #{youtube_url}`.strip + '.mp3'
  end

  def file_path
    "#{MUSICS_PATH}/#{file_name}"
  end

  private

  attr_reader :youtube_url

  def output
    "--output '#{MUSICS_PATH}/%(title)s-%(id)s.%(ext)s'"
  end

  def audio_configurations
    "--extract-audio --audio-quality 0 --audio-format mp3"
  end
end
