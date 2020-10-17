require 'chunky_png'
require 'quirc'

class QrDecoder
  def initialize(image_src)
    @image_src = image_src
  end

  def perform
    img = ChunkyPNG::Image.from_file(@image_src)
    res = Quirc.decode(img).first
    res.payload
  end
end