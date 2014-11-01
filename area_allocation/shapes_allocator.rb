require_relative 'two_neighbor_pixels'
require_relative 'shape'
require_relative 'support'
require_relative 'pixels_allocator'

class ShapesAllocator
  def initialize(image)
    @image = image
  end

  def allocate
    @view_pixels = @image.view(0, 0, @image.columns, @image.rows)
    @view_pixels = PixelsAllocator.new(@view_pixels).allocate

    grouped_pixels = @view_pixels.group_by(&:area_number)
    grouped_pixels.delete(nil)
    grouped_pixels.map { |area_number, pixels| Shape.new(pixels, @view_pixels) }
  end

  def sync
    @view_pixels.sync
  end

end
