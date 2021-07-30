class HomeController < ApplicationController
  def index; end

  def download
    binding.pry
  end

  private

  def allowed_parameters
    params.permit(:youtube_url)
  end
end
