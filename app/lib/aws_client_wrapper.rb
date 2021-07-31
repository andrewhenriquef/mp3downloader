# frozen_string_literal: true

class AwsClientWrapper
  def initialize(path_to_file:, file_name:)
    @path_to_file = path_to_file
    @file_name = file_name
  end

  def save_file_and_generate_link_to_download!
    upload_file_to_aws!
    generate_url_to_download_file!
  end

  private

  attr_reader :path_to_file, :file_name

  def upload_file_to_aws!
    File.open(path_to_file) do |file|
      object.upload_file(file, { content_type: 'audio/mpeg', content_disposition: 'attachment' })
    end
  end

  def generate_url_to_download_file!
    object.presigned_url(:get)
  end

  def object
    @object ||= bucket.object(file_name)
  end

  def bucket
    resource.bucket(Rails.application.credentials.dig(:aws, :bucket))
  end

  def resource
    Aws::S3::Resource.new(
      region: Rails.application.credentials.dig(:aws, :region),
      credentials: aws_credentials
    )
  end

  def aws_credentials
    Aws::Credentials.new(
      Rails.application.credentials.dig(:aws, :access_key_id),
      Rails.application.credentials.dig(:aws, :secret_access_key)
    )
  end
end
