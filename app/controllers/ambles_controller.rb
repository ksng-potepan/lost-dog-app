class AmblesController < ApplicationController
  before_action :authenticate_user!

  def information
    @user = current_user
  end

  def index
    @user = current_user
    @amble = Amble.all
  end

  def show
    @user = current_user
    @amble = Amble.where(id: params[:id])
  end

  def new
    @user = current_user
    @amble = Amble.new
  end

  def edit
    @user = current_user
    @amble = Amble.find(params[:id])
  end

  def create
    @user = current_user
    @amble = Amble.new(amble_params)
    @amble.user_id = current_user.id
    if @amble.save
      flash[:notice] = t('flash.notices.create')
      redirect_to amble_path(@amble)
    else
      flash.now[:alert] = t('flash.alerts.create_fail')
      render :new
    end
  end

  def update
    @user = current_user
    @amble = Amble.find(params[:id])
    @amble.user_id = current_user.id
    if @amble.update(amble_params)
      flash[:notice] = t('flash.notices.update')
      redirect_to amble_path(@amble)
    else
      flash.now[:alert] = t('flash.alerts.update_fail')
      render :edit
    end
  end

  def destroy
    @amble = Amble.find(params[:id])
    @amble.destroy
    flash[:notice] = t('flash.notices.destroy')
    redirect_to ambles_url(@amble)
  end

  private

  def amble_params
    params.require(:amble).permit(:name, :breed, :size, :gender, :color, :age, :features, :tag, :chip, :date, :time,
                                  :prefecture, :municipalities, :area, :situation, :notification, :image)
  end
end
