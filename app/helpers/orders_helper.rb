module OrdersHelper
  
  def sortable(column, title = nil)
    title ||= column.capitalize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge!(:sort => column, :direction => direction, :authenticity_token => nil), {:class => "sort-header", :method => :get}
  end

  def arrow(column)
    if params[:direction] == "asc"
      raw("<span class='glyphicon glyphicon-sort-by-order sort' aria-hidden='true'></span>")
    elsif params[:direction] == "desc"
      raw("<span class='glyphicon glyphicon-sort-by-order-alt sort' aria-hidden='true'></span>")
    else
      raw("<span class='glyphicon glyphicon-sort sort' aria-hidden='true'></span>")
    end
  end

  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def receive_check(status)
    if status == true
      "YES"
    else
      ""
    end
  end

end
