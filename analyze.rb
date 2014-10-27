require 'benchmark'
require 'RMagick'
require 'pry'
require 'gruff'
require 'yaml'
require_relative 'area_allocation/area_allocator'
require_relative 'clusterizing/clusterizer'

include Magick

class MainAnalyzer
  def analyze
    check_input_parameters
    @spoons_image = ImageList.new(@image_file)
    shapes = allocate_pixels(@spoons_image)
    clusterize_shapes(shapes)
    # annotate_shapes(@spoons_image, shapes)
  end

  def output
    @view_pixels.sync
    @spoons_image.write(@output_file_name + '.jpg')
    ImageList.new(@output_file_name + '.jpg', @output_file_name + '_chart.png').display
  end

  private

  def error(text)
    puts("Error: #{text}.")
    exit
  end

  def check_input_parameters
    if ARGV.count != 3
      error('script accepts 3 input parameters (input image, output file name, number of clusters)')
    end

    @image_file = ARGV[0]
    if !File.exist?(@image_file)
      error("first argument must be an existing file")
    end

    @output_file_name = ARGV[1]

    @clusters_number = ARGV[2]
    if @clusters_number.to_i.to_s != @clusters_number
      error('third argument must be a number')
    end
    @clusters_number = @clusters_number.to_i
  end

  def annotate_shapes(image, shapes)
    shapes.each_with_index do |shape, index|
      Draw.new.annotate(image, 100, 50, shape.pixels.first.x, shape.pixels.first.y, index.to_s)
    end
  end

  def allocate_pixels(spoons_image)
    @view_pixels = spoons_image.view(0, 0, spoons_image.columns, spoons_image.rows)
    @view_pixels = AreaAllocator.new(@view_pixels).allocate

    grouped_pixels = @view_pixels.group_by(&:area_number)
    grouped_pixels.delete(nil)
    shapes = grouped_pixels.map { |area_number, pixels| Shape.new(pixels, @view_pixels) }
  end

  def clusterize_shapes(shapes)
    clusterizer = Clusterizer.new(shapes.map { |shape| shape.vector_properties })
    clusters = clusterizer.clusterize(@clusters_number.to_i, draw_chart: true, chart_name: @output_file_name)
    shapes.each do |shape|
      cluster_number = clusters.index { |cluster| cluster.include?(shape.vector_properties) }
      shape.paintings[cluster_number].call
    end
  end
end

analyzer = MainAnalyzer.new
analyzer.analyze
analyzer.output
