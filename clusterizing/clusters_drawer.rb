require 'gruff'
class Clusterizing::ClustersDrawer
  def initialize(clusters)
    @clusters = clusters
  end

  def draw_chart(chart_name)
    draw_gruff_chart(chart_name)
    draw_gnuplot_chart
  end

  private

  def draw_gruff_chart(chart_name=nil)
    g = Gruff::Scatter.new
    g.title = 'Vectors of properties'

    @clusters.each.with_index do |cluster, index|
      g.data(index.to_s, cluster.map { |vector| vector[0] }, cluster.map { |vector| vector[1] })
    end
    g.write("#{chart_name}_chart.png")
  end

  def draw_gnuplot_chart
    Clusterizing::Vector.write_vectors_to_dat_file(@clusters.flatten)
  end

end
