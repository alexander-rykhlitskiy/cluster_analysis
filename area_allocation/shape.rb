require_relative 'paintable'
class Shape
  include Paintable
  VECTOR_PROPERTIES = [:square, :perimeter, :compactness]

  attr_reader :pixels

  def initialize(pixels, view_pixels)
    @pixels, @view_pixels = pixels, view_pixels
  end

  def not_valid?
    square < 30
  end

  def vector_properties
    VECTOR_PROPERTIES.map { |prop| public_send(prop) }
  end

  def inspect
    "#{self.class}: #{self.object_id}, square: #{square}, perimeter: #{perimeter}, compactness: #{compactness}"
  end

  def square
    @pixels.count
  end

  def perimeter
    return @perimeter if !@perimeter.nil?

    @perimeter = 0

    @pixels.each do |pix|
        neighbors_coordinates = []
        neighbors_coordinates << { x: pix.x-1, y: pix.y } if pix.x > 1
        neighbors_coordinates << { x: pix.x, y: pix.y-1 } if pix.y > 1
        neighbors_coordinates << { x: pix.x+1, y: pix.y } if pix.x < @view_pixels.width - 1
        neighbors_coordinates << { x: pix.x, y: pix.y+1 } if pix.y < @view_pixels.height - 1

        border = neighbors_coordinates.any? do |xy|
          @view_pixels[xy[:y]][xy[:x]].color_label != pix.color_label
        end
        if border
          @perimeter += 1
        end
    end
    @perimeter
  end

  def compactness
    (perimeter ** 2) / square
  end

  def to_yaml
    VECTOR_PROPERTIES.map { |prop| [prop, public_send(prop)] }.to_h
  end
end
