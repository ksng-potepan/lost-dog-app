class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:top]

  def top
    @user = current_user
    @sightings = Sighting.order(created_at: :desc).limit(3)
  end

  def information
    @user = current_user
  end
end
