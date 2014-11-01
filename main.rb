require 'benchmark'
require 'RMagick'
require 'pry'
require 'gruff'
require 'yaml'
require_relative 'area_allocation/shapes_allocator'
require_relative 'clusterizing/clusterizer'
require_relative 'shapes_clusterizer'

include Magick

class MainAnalyzer
  def analyze
    check_input_parameters
    @spoons_image = ImageList.new(@image_file).gaussian_blur(0, @blur_coefficient)

    @allocator = ShapesAllocator.new(@spoons_image)
    shapes = @allocator.allocate

    shapes_clusterizer = ShapesClusterizer.new(shapes)
    shapes_clusterizer.clusterize(@clusters_number, @output_file_name)
    shapes_clusterizer.annotate_shapes(@spoons_image)
  end

  def output
    @allocator.sync
    @spoons_image.write(@output_file_name + '.jpg')
    ImageList.new(@output_file_name + '.jpg', @output_file_name + '_chart.png').display
  end

  private

  def error(text)
    puts("Error: #{text}.")
    exit
  end

  def check_input_parameters
    if ARGV.count < 3
      error('script accepts minimum 3 input parameters (input image, output file name, number of clusters)')
    end

    @image_file = ARGV[0]
    if !File.exist?(@image_file)
      error("first argument must be an existing file")
    end

    @output_file_name = ARGV[1]

    @clusters_number = ARGV[2]
    if @clusters_number.to_i.to_s != @clusters_number
      error('third argument must be integer')
    end
    @clusters_number = @clusters_number.to_i

    @blur_coefficient = ARGV[3]
    if @blur_coefficient.to_f.to_s != @blur_coefficient
      error('fourth argument must be a float number')
    end
    @blur_coefficient = @blur_coefficient.to_f
  end

end

analyzer = MainAnalyzer.new
analyzer.analyze
analyzer.output
