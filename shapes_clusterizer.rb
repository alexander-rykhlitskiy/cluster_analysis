class ShapesClusterizer
  def initialize(shapes)
    @shapes = shapes.reject(&:not_valid?)
    @shapes_cluster_numbers = {}
  end

  def clusterize(clusters_number, output_file_name)
    clusterizer = Clusterizing::Clusterizer.new(@shapes.map { |shape| shape.vector_properties })
    clusters = clusterizer.clusterize(clusters_number.to_i)
    clusterizer.draw_chart(output_file_name)

    @shapes.each do |shape|
      cluster_number = clusters.index { |cluster| cluster.include?(shape.vector_properties) }
      @shapes_cluster_numbers[shape] = cluster_number
      shape.paintings[cluster_number].call
    end
  end

  def annotate_shapes(image)
    @shapes.each_with_index do |shape, index|
      annotation = "#{index.to_s} - #{@shapes_cluster_numbers[shape]}"
      Draw.new.annotate(image, 100, 50, shape.pixels.first.x, shape.pixels.first.y, annotation)
    end
  end

end
