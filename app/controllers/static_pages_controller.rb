class StaticPagesController < ApplicationController

  def home
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id).limit(10).uniq
  end

end
