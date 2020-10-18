class QrDecoder
  def initialize(file_path)
    @file_path = file_path
  end

  def perform
    transform_file_format unless @file_path.end_with?('.png')
    img = ChunkyPNG::Image.from_file(@file_path)
    res = Quirc.decode(img).first
    # borrar imagen
    raise Errors::InvalidQR unless res.present?
    res.payload
  end

  private

  def transform_file_format
    # crear nueva copia y borrar la anterior (esto va en el poro!!)
    image = MiniMagick::Image.open(@file_path)
    image.format('png')
    image.write(@file_path + '.png')
    @file_path = @file_path + '.png'
  end
end