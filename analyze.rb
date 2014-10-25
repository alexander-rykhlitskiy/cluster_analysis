require 'RMagick'
require 'pry'
require_relative 'support'
require_relative 'area_allocator'

include Magick

spoons_image = ImageList.new('spoons.jpg')

pixels = spoons_image.view(0, 0, spoons_image.columns, spoons_image.rows)

pixels = AreaAllocator.new(pixels).allocate

def clusterize_pixel_groups(grouped_pixels)
  grouped_pixels.each_with_object({}) do |(group_number, pixels), result|
    result[pixels.count/3000] ||= []
    result[pixels.count/3000] << pixels
  end
end


grouped_pixels = pixels.group_by(&:area_number)
clusterize_pixel_groups(grouped_pixels).each do |cluster_number, pixel_group|
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


pixels.sync
spoons_image.display
