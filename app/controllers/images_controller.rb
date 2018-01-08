class ImagesController < ApplicationController
  def show
    uuid = params[:uuid]
    @image = Image.find_by(image: uuid)
  end
end
