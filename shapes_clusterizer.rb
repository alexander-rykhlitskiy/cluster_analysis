class ShapesClusterizer
  def initialize(shapes)
    @shapes = shapes.reject(&:not_valid?)
    @shapes_cluster_numbers = {}
  end

  def clusterize(clusters_number, output_file_name)
    properties = @shapes.map { |shape| shape.vector_properties }
    properties = properties_relatively_to_min_property(properties)

    clusterizer = Clusterizing::Clusterizer.new(properties)
    clusterized_properties = clusterizer.clusterize(clusters_number.to_i)
    clusterizer.draw_chart(output_file_name)

    @shapes.each do |shape|
      cluster_number = clusterized_properties[@shapes.index(shape)]
      @shapes_cluster_numbers[shape] = cluster_number
      shape.paintings[cluster_number].call
    end
  end

  def annotate_shapes(image)
    @shapes.each_with_index do |shape, index|
      annotation = "#{index.to_s}-#{@shapes_cluster_numbers[shape]}-#{shape.vector_properties.join(';')}"
      Draw.new.annotate(image, 100, 50, shape.pixels.first.x, shape.pixels.first.y, annotation)
    end
  end

  private

  def properties_relatively_to_min_property(properties)
    min_vector = properties.first.map.with_index do |prop, i|
      properties.map { |x| x[i] }.min
    end
    properties.map do |props_vector|
      props_vector.map.with_index do |prop, i|
        prop.to_f / min_vector[i]
      end
    end
  end

end
