# require 'pry'
require 'benchmark'
require 'RMagick'
require_relative 'area_allocation/support'
include Magick

@image = ImageList.new('spoons.jpg')
# counter = 0
# array = Array.new(625) { Array.new(391) }
# for x in array do
#   for y in x do
#     counter += 1
#   end
# end

# view_pixels = @image.view(0, 0, @image.columns, @image.rows)
# view_pixels.each do |pix, x, y|
#   # counter += 1
#   pix.x, pix.y = x, y
#   if ((pix.red + pix.green + pix.blue) / 3) < 40_000
#     # pix.red = pix.green = pix.blue = 0
#     pix.color_label = 0
#   else
#     # pix.red = pix.green = pix.blue = MAX_INT
#     pix.color_label = 1
#     # compare_pixel_to_neighbors(pix, x, y)
#   end
# end
# view_pixels.sync
# pixels = Array.new(@image.columns) do |column|
#   @image.get_pixels(column, 0, 1, @image.rows)
# end

# pixels.each_with_index do |p_column, x|
#   p_column.each_with_index do |pix, y|
#     pix.x, pix.y = x, y
#     if ((pix.red + pix.green + pix.blue) / 3) < 40_000
#       # @image.pixel_color(x, y, '#000')
#       # pix.red = pix.green = pix.blue = 0
#       pix.color_label = 0
#     else
#       # @image.pixel_color(x, y, '#000')
#       # pix.red = pix.green = pix.blue = MAX_INT
#       pix.color_label = 1
#       # compare_pixel_to_neighbors(pix, x, y)
#     end
#   end
# end
# (0...@image.columns).each do |column|
#   @image.store_pixels(column, 0, 1, @image.rows, pixels[column])
# end
def old
  view_pixels = @image.view(0, 0, @image.columns, @image.rows)
  view_pixels.each do |pix, x, y|
    pix.x, pix.y = x, y
    if ((pix.red + pix.green + pix.blue) / 3) < 40_000
      pix.color_label = 0
    else
      pix.color_label = 1
    end
  end
  view_pixels.sync
end

def new_m
  pixels = Array.new(@image.columns) do |column|
    @image.get_pixels(column, 0, 1, @image.rows)
  end

  pixels.each_with_index do |p_column, x|
    p_column.each_with_index do |pix, y|
      pix.x, pix.y = x, y
      if ((pix.red + pix.green + pix.blue) / 3) < 40_000
        pix.color_label = 0
      else
        pix.color_label = 1
      end
    end
  end
  (0...@image.columns).each do |column|
    @image.store_pixels(column, 0, 1, @image.rows, pixels[column])
  end
end

# p 'new:'
# p Benchmark.measure { 5.times { new_m } }
p 'old:'
p Benchmark.measure { 5.times { old } }

@image.write('output.jpg')
