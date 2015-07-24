module ReportsHelper

  def generate_chart_profit(this_year)
    graph_data = Hash.new(0)
    this_year.each do |data|
      graph_data[data.month_record] = data.revenue.to_f
    end
    return graph_data
  end

  def generate_chart_cost(this_year)
    graph_data = Hash.new(0)
    this_year.each do |data|
      graph_data[data.month_record] = data.total_cost.to_f
    end
    return graph_data
  end

  def generate_chart_selling(this_year)
    graph_data = Hash.new(0)
    this_year.each do |data|
      graph_data[data.month_record] = data.total_selling.to_f
    end
    return graph_data
  end

end
