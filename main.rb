require 'benchmark'
require 'RMagick'
require 'pry'
require 'gruff'
require 'yaml'
require_relative 'area_allocation/shapes_allocator'
require_relative 'clusterizing/clusterizer'
require_relative 'shapes_clusterizer'
require_relative 'args_parser'

include Magick

class MainAnalyzer
  def initialize(args)
    @image_path = args[:image_path]
    @clusters_number = args[:clusters_number]
    @blur_coefficient = args[:blur_coefficient]
    @black_limit_coefficient = args[:black_limit_coefficient]
    @output_file_name = args[:output_file_name] || 'output'
    @annotate_shapes = args[:annotate_shapes]
  end

  def analyze
    @spoons_image = ImageList.new(@image_path)
    unless @blur_coefficient.nil?
      @spoons_image = @spoons_image.gaussian_blur(0, @blur_coefficient)
    end

    allocator = ShapesAllocator.new(@spoons_image)
    shapes = allocator.allocate(@black_limit_coefficient)

    shapes_clusterizer = ShapesClusterizer.new(shapes)
    shapes_clusterizer.clusterize(@clusters_number, @output_file_name)
    allocator.sync
    shapes_clusterizer.annotate_shapes(@spoons_image) if @annotate_shapes
  end

  def output
    @spoons_image.write(@output_file_name + '.jpg')
    ImageList.new(@output_file_name + '.jpg', @output_file_name + '_chart.png')#.display
  end
end


# binding.pry
# shapes = Shape.load_yaml
# clusterizer = Clusterizing::Clusterizer.new(shapes.map(&:values))
# clusters = clusterizer.clusterize(4)

analyzer = MainAnalyzer.new(ArgsParser.parse)
analyzer.analyze
analyzer.output
