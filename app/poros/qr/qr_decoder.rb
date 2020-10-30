module Qr
  class QrDecoder
    def initialize(file_path)
      @file_path = file_path
    end

    def perform
      convert_to_png unless @file_path.end_with?('.png')

      img = ChunkyPNG::Image.from_file(@file_path)
      res = Quirc.decode(img).first
      raise Errors::InvalidQR unless res.present?
      res.payload
    end

    private

    def convert_to_png
      # crear nueva copia y borrar el tempfile anterior (esto va en el poro!!)
      image = MiniMagick::Image.open(@file_path)
      image.format('png')
      @file_path = image.tempfile.path
      # we should do smth like image.destroy! to destroy the tempfile
    end
  end
end