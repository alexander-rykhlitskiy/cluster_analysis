require 'gruff'
require_relative 'vector'
require_relative 'center'

class Clusterizer
  def initialize(properties_vectors)
    @vectors = properties_vectors.map { |properties_vector| Vector.new(properties_vector) }
    @vectors = @vectors.sort_by { |vec| vec.distance_from_start }
  end

  def clusterize(clusters_number, draw_chart: false, chart_name: nil)
    set_centers(clusters_number)
    last_vectors, current_vectors = [], @centers.map(&:vectors)

    counter = 0
    while(last_vectors != current_vectors) do
      counter += 1
      last_vectors = current_vectors.map { |vector| vector.dup }
      reset_clusters

      current_vectors = @centers.map(&:vectors)
      reset_centers
    end
    puts "Vectors were clustered in #{counter} cycles."

    reset_clusters

    clusters = @centers.map(&:vectors).reject(&:empty?)
    draw_chart(clusters, chart_name) if draw_chart

    clusters.map do |cluster|
      cluster.map do |vector|
        vector.properties
      end
    end
  end

  private

  # ToDo: better choice of initial cluster centers
  def set_centers(clusters_number)
    initial_center = Center.new(Array.new(@vectors.first.properties.count), @vectors)

    @centers = [initial_center.get_mass_center]

    return if clusters_number < 2
    @centers += @vectors.take(1).map(&:to_center)

    return if clusters_number == 2
    @centers += @vectors.reverse.take(clusters_number - 2).map(&:to_center)
  end

  def reset_clusters
    @vectors.each do |vector|
      closest_center = @centers.min_by { |center| center.distance_to(vector) }
      closest_center << vector
    end
  end

  def reset_centers
    @centers = @centers.map(&:get_mass_center)
  end

  def draw_chart(clusters, chart_name=nil)
    g = Gruff::Scatter.new
    g.title = 'Vectors'

    clusters.each.with_index do |cluster, index|
      g.data(index.to_s, cluster.map { |vector| vector[0] }, cluster.map { |vector| vector[1] })
    end
    g.write("#{chart_name}_chart.png")
  end

end
