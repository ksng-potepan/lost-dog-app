class HomeController < ApplicationController
before_action :authenticate_user!, except: [:top]

  def top
    @user = current_user
  end

  def information
    @user = current_user
  end
end
