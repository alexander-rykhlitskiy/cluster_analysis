require_relative 'paintable'
class Shape
  include Paintable
  VECTOR_PROPERTIES = [:square, :perimeter, :compactness]# , :elongation]

  attr_reader :pixels, *VECTOR_PROPERTIES

  def initialize(pixels, bitmap)
    @pixels, @bitmap = pixels, bitmap
    calculate_properties
  end

  def not_valid?
    @square < 30
  end

  def vector_properties
    VECTOR_PROPERTIES.map { |prop| public_send(prop) }
  end

  def inspect
    properties = VECTOR_PROPERTIES.map { |prop| "#{prop}: #{public_send(prop)}"}.join(', ')
    "#{self.class}: #{self.object_id}, #{properties}"
  end

  def to_h
    VECTOR_PROPERTIES.map { |prop| [prop, public_send(prop)] }.to_h
  end

  class << self
    FILE_NAME = 'shapes.yml'

    def shapes_to_yaml(shapes)
      File.write(FILE_NAME, shapes.map(&:to_h).to_yaml)
    end

    def load_yaml
      YAML.load(File.read(FILE_NAME))
    end
  end

  private

  def calculate_properties
    perimeter = 0
    mass_x = mass_y = 0

    @pixels.each do |pix|
      mass_x += pix.x
      mass_y += pix.y

      perimeter += 1 if is_pixel_on_border?(pix)
    end

    @square = @pixels.count
    @perimeter =  perimeter
    @mass_center_x = (mass_x / @square)
    @mass_center_y = (mass_y / @square)
    @compactness = (@perimeter ** 2) / @square
    calculate_elongation
  end

  def is_pixel_on_border?(pix)
    neighbor_pixels = [@bitmap[pix.x-1][pix.y], @bitmap[pix.x][pix.y-1],
                       @bitmap[pix.x+1][pix.y], @bitmap[pix.x][pix.y+1]]

    neighbor_pixels.any? { |neighb| neighb.color_label != pix.color_label }
  end

  def calculate_elongation
    m20 = m02 = m11 = 0

    @pixels.each do |pix|
      m20 += (pix.x - @mass_center_x) ** 2
      m02 += (pix.y - @mass_center_y) ** 2
      m11 = (pix.x - @mass_center_x) * (pix.y - @mass_center_y)
    end

    sum = m20 + m02
    sqrt = Math.sqrt(((m20 - m02) ** 2) + (4 * (m11 ** 2)))
    @elongation = (sum + sqrt) / (sum - sqrt)
  end
end
