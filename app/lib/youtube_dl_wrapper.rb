# frozen_string_literal: true

class YoutubeDlWrapper
  MUSICS_PATH = Rails.root.join('tmp', 'musics').to_s.freeze
  YOUTUBE_DL = 'bin/youtube-dl'.freeze

  def initialize(youtube_url:)
    @youtube_url = youtube_url
  end

  def download
    download_mp3!
    file_path
  end

  def file_name
    @file_name ||= `#{YOUTUBE_DL} --get-title #{youtube_url}`.strip.gsub('/', '_') + '.mp3'
  end

  def file_path
    @file_path ||= "#{MUSICS_PATH}/#{file_name}"
  end

  private

  attr_reader :youtube_url

  def download_mp3!
    `#{YOUTUBE_DL} #{audio_configurations} #{output} #{youtube_url}`
  end

  def output
    "--output '#{MUSICS_PATH}/%(title)s.%(ext)s'"
  end

  def audio_configurations
    "--extract-audio --audio-quality 0 --audio-format mp3"
  end
end
