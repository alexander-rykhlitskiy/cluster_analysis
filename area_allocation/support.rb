MAX_INT = 256 * 256 - 1

class Magick::Image::View
  def each(&block)
    for x in (0...self.width) do
      for y in (0...self.height) do
        yield(self[y][x], x, y)
      end
    end
  end

  def map(&block)
    result = []
    each { |pix| result << yield(pix) }
    result
  end

  def group_by(&block)
    result = {}
    each do |pix|
      key = yield(pix)
      result[key] ||= []
      result[key] << pix
    end
    result
  end

end

class Magick::Pixel
  attr_accessor :color_label, :area_number, :x, :y
end
