class SightingsController < ApplicationController
  before_action :authenticate_user!

  def information
    @user = current_user
  end

  def index
    @user = current_user
    @sightings = Sighting.all.page(params[:page]).per(10)
    if params[:search].present?
      @sightings = @sightings.where('time LIKE ? or area LIKE ? or situation LIKE ?',
                                    "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    return unless params[:start_date].present? || params[:end_date].present?

    @sightings = if params[:start_date].present? && params[:end_date].present?
                   @sightings.where(date: params[:start_date]..params[:end_date])
                 elsif params[:start_date].present?
                   @sightings.where(date: params[:start_date]..)
                 else
                   @sightings.where(date: ..params[:end_date])
                 end
  end

  def show
    @user = current_user
    @sighting = Sighting.find(params[:id])
    @sighting_user = Sighting.find_by(id: params[:id])
    @current_entry = Entry.where(user_id: @user.id)
    @another_entry = Entry.where(user_id: @sighting_user.user.id)

    @current_entry.each do |current|
      @another_entry.each do |another|
        if current.room_id == another.room_id
          @is_room = true
          @room_id = current.room_id
        end
      end
    end
    return if @is_room

    @room = Room.new
    @entry = Entry.new
  end

  def new
    @user = current_user
    @sighting = Sighting.new
  end

  def edit
    @user = current_user
    @sighting = Sighting.find(params[:id])
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

  def update
    @user = current_user
    @sighting = Sighting.find(params[:id])
    @sighting.user_id = current_user.id
    if @sighting.update(sighting_params)
      flash[:notice] = t('flash.notices.update')
      redirect_to sighting_path(@sighting)
    else
      flash.now[:alert] = t('flash.alerts.update_fail')
      render :edit
    end
  end

  def destroy
    @sighting = Sighting.find(params[:id])
    @sighting.destroy
    redirect_to sightings_path
  end

  def mysighting
    @user = current_user
    @sighting = Sighting.where(user_id: current_user.id).page(params[:page]).per(10)
  end

  def list
    @user = current_user
    @sighting = Sighting.where(user_id: params[:id]).page(params[:page]).per(10)
  end

  def topic
    @sighting = Sighting.order(created_at: :desc).limit(3)
  end

  private

  def sighting_params
    params.require(:sighting).permit(:date, :time, :area, :situation, :image, :lat, :lng, :user_id)
  end
end
