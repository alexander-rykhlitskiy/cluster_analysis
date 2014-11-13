class Bitmap
  include Enumerable
  extend Forwardable
  def_delegators :@pixels, :[]

  attr_reader :width, :height

  def initialize(image)
    @image = image
    @width, @height = image.columns, image.rows

    @pixels = Array.new(@width) do |column|
      @image.get_pixels(column, 0, 1, @image.rows)
    end
  end

  def each_with_xy(&block)
    @pixels.each_with_index do |pixels_column, x|
      pixels_column.each_with_index do |pix, y|
        yield(pix, x, y)
      end
    end
  end

  def each(&block)
    @pixels.flatten.each do |pix|
      yield pix
    end
  end

  def sync
    (0...@width).each do |column|
      @image.store_pixels(column, 0, 1, @height, @pixels[column])
    end
  end

end
