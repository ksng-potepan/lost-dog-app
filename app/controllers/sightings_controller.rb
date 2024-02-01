class SightingsController < ApplicationController
  before_action :authenticate_user!

  def information
    @user = current_user
  end

  def index
    @user = current_user
    @sighting = Sighting.all
  end

  def show
    @user = current_user
    @sighting = Sighting.find(params[:id])
  end

  def new
    @user = current_user
    @sighting = Sighting.new
  end

  def create
    @user = current_user
    @sighting = Sighting.new(sighting_params)
    @sighting.user_id = current_user.id
    if @sighting.save
      flash[:notice] = t('flash.notices.create')
      redirect_to sightings_path
    else
      flash.now[:alert] = t('flash.alerts.create_fail')
      render :new
    end
  end

  def destroy
    @sighting = Sighting.find(params[:id])
    @sighting.destroy
    redirect_to sightings_path
  end

  def mysighting
    @user = current_user
    @sighting = Sighting.where(user_id: current_user.id)
  end

  def list
    @user = current_user
    @sighting = Sighting.where(user_id: params[:id])
  end

  def topic
    @sighting = Sighting.order(created_at: :desc).limit(3)
  end

  private

  def sighting_params
    params.require(:sighting).permit(:date, :time, :area, :situation, :image, :lat, :lng, :user_id)
  end
end
