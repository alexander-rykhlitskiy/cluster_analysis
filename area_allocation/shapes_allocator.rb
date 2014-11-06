require_relative 'two_neighbor_pixels'
require_relative 'shape'
require_relative 'support'
require_relative 'pixels_allocator'
require_relative 'bitmap'

class ShapesAllocator
  def initialize(image)
    @image = image
    @bitmap = Bitmap.new(@image)
  end

  def allocate(black_limit_coefficient)
    @bitmap = PixelsAllocator.new(@bitmap).allocate(black_limit_coefficient)

    grouped_pixels = @bitmap.group_by(&:area_number)
    grouped_pixels.delete(nil)
    grouped_pixels.map { |area_number, pixels| Shape.new(pixels, @bitmap) }
  end

  def sync
    @bitmap.sync
  end

end
