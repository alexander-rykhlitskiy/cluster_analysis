module Clusterizing

  require_relative 'vector'
  require_relative 'center'
  require_relative 'clusters_drawer'

  class Clusterizer
    extend Forwardable
    delegate draw_chart: :@drawer

    def initialize(initial_properties)
      @initial_properties = initial_properties
      @vectors = initial_properties.map { |properties_vector| Vector.new(properties_vector) }
    end

    def clusterize(clusters_number)
      set_initial_centers(clusters_number)
      last_vectors, current_vectors = [], @centers.map(&:vectors)

      counter = 0
      while(last_vectors != current_vectors) do
        counter += 1
        last_vectors = current_vectors.map { |vector| vector.dup }
        reset_clusters

        current_vectors = @centers.map(&:vectors)
        reset_centers
      end
      # puts "Vectors were clustered in #{counter} cycles."

      reset_clusters

      @clusters = @centers.map(&:vectors).reject(&:empty?)
      @drawer = ClustersDrawer.new(@clusters)

      generate_output
    end

    private

    def generate_output
      clusterized_properties = @clusters.map do |cluster|
        cluster.map do |vector|
          vector.properties
        end
      end
      @initial_properties.each.with_index.each_with_object({}) do |(var, index), mem|
        mem[index] = clusterized_properties.index { |props| props.include?(var)}
      end
    end

    # ToDo: better choice of initial cluster centers
    def set_initial_centers(clusters_number)
      @vectors = @vectors.sort_by { |vec| vec.distance_from_start }
      initial_center = Center.new(Array.new(@vectors.first.properties.count), @vectors)

      @centers = [initial_center.get_area_mass_center]

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
      @centers = @centers.map(&:get_area_mass_center)
    end
  end
end
