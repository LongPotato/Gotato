module StaticPagesHelper

  def greeting_message
    current_time = Time.now.to_i
    midnight = Time.now.beginning_of_day.to_i
    noon = Time.now.middle_of_day.to_i
    five_pm = Time.now.change(:hour => 17 ).to_i
    eight_pm = Time.now.change(:hour => 20 ).to_i

    if midnight.upto(noon).include?(current_time)
      "Good morning"
    elsif noon.upto(five_pm).include?(current_time)
      "Good afternoon"
    elsif five_pm.upto(eight_pm).include?(current_time)
      "Good evening"
    elsif eight_pm.upto(midnight + 1.day).include?(current_time)
      "Good night"
    end
  end

  def display_name(name)
    if current_user.name == name
      "You"
    else
      name
    end
  end

end
