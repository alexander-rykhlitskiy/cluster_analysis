MAX_INT = 256 * 256 - 1

class Magick::Pixel
  attr_accessor :color_label, :area_number, :x, :y
  def inspect
    "Pixel:#{object_id}; color_label: #{color_label}; x: #{x}; y: #{y}; area_number: #{area_number}"
  end
end
