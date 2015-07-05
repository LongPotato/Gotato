module OrdersHelper

  def length_control(column, text, size)
    if text.length > size
      raw("#{text[0..size]} <a class='extend-link' href='/users/#{column.user.id}/orders/#{column.id}'>
        <span class='glyphicon glyphicon-triangle-right'></span>
        </a> ")
    else
      raw("#{text}")
    end
  end

end
