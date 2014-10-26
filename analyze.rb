require 'benchmark'
require 'RMagick'
require 'pry'
require_relative 'support'
require_relative 'area_allocator'
require_relative 'shape'

include Magick

spoons_image = ImageList.new('spoons.jpg')

view_pixels = spoons_image.view(0, 0, spoons_image.columns, spoons_image.rows)
view_pixels = AreaAllocator.new(view_pixels).allocate

def clusterize_pixel_groups(grouped_pixels)
  grouped_pixels.each_with_object({}) do |pixels, result|
    result[pixels.count/3000] ||= []
    result[pixels.count/3000] << pixels
  end
end

shapes = view_pixels.group_by(&:area_number).map { |area_number, pixels| Shape.new(pixels) }

clusterize_pixel_groups(shapes.map(&:pixels)).each do |cluster_number, pixel_group|
  color = case cluster_number
  when 0
    'red'
  when 1
    'green'
  else
    'blue'
  end
  pixel_group.flatten.each do |pix|
    pix.send(color + '=', 0)
  end
end

view_pixels.sync
spoons_image.write('clusterized_spoons.jpg')
spoons_image.display
exit
