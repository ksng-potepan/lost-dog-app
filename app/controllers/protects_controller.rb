class ProtectsController < ApplicationController
  before_action :authenticate_user!

  def information
    @user = current_user
  end

  def index
    @user = current_user
    @protect = Protect.all
    if params[:search].present?
      @protect = @protect.where('name LIKE ? or breed LIKE ? or color LIKE ? or features LIKE ?
                                or age LIKE ? or municipalities LIKE ? or area LIKE ?',
                                "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%",
                                "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @protect = @protect.where(prefecture: params[:prefecture]) if params[:prefecture].present?
    @protect = @protect.where(size: params[:size]) if params[:size].present?
    return unless params[:start_date].present? || params[:end_date].present?

    @protect = if params[:start_date].present? && params[:end_date].present?
                 @protect.where(date: params[:start_date]..params[:end_date])
               elsif params[:start_date].present?
                 @protect.where(date: params[:start_date]..)
               else
                 @protect.where(date: ..params[:end_date])
               end
  end

  def show
    @user = current_user
    @protect = Protect.where(id: params[:id])
    @protect_user = Protect.find_by(id: params[:id])
    @current_entry = Entry.where(user_id: @user.id)
    @another_entry = Entry.where(user_id: @protect_user.user.id)

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
    @protect = Protect.new
  end

  def edit
    @user = current_user
    @protect = Protect.find(params[:id])
  end

  def create
    @user = current_user
    @protect = Protect.new(protect_params)
    @protect.user_id = current_user.id
    if @protect.save
      flash[:notice] = t('flash.notices.create')
      redirect_to protect_path(@protect)
    else
      flash.now[:alert] = t('flash.alerts.create_fail')
      render :new
    end
  end

  def update
    @user = current_user
    @protect = Protect.find(params[:id])
    @protect.user_id = current_user.id
    if @protect.update(protect_params)
      flash[:notice] = t('flash.notices.update')
      redirect_to protect_path(@protect)
    else
      flash.now[:alert] = t('flash.alerts.update_fail')
      render :edit
    end
  end

  def destroy
    @protect = Protect.find(params[:id])
    @protect.destroy
    flash[:notice] = t('flash.notices.destroy')
    redirect_to protects_url
  end

  def myprotect
    @user = current_user
    @protect = Protect.where(user_id: current_user.id)
  end

  def list
    @user = current_user
    @protect = Protect.where(user_id: params[:id])
  end

  def transferred
    @user = current_user
    @protect = Protect.where(transferred: true)
    if params[:search].present?
      @protect = @protect.where('name LIKE ? or breed LIKE ? or color LIKE ? or features LIKE ?
                                or age LIKE ? or municipalities LIKE ? or area LIKE ?',
                                "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%",
                                "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @protect = @protect.where(prefecture: params[:prefecture]) if params[:prefecture].present?
    @protect = @protect.where(size: params[:size]) if params[:size].present?
    return unless params[:start_date].present? || params[:end_date].present?

    @protect = if params[:start_date].present? && params[:end_date].present?
                 @protect.where(date: params[:start_date]..params[:end_date])
               elsif params[:start_date].present?
                 @protect.where(date: params[:start_date]..)
               else
                 @protect.where(date: ..params[:end_date])
               end
  end

  private

  def protect_params
    params.require(:protect).permit(:name, :breed, :size, :gender, :color, :age, :features, :tag, :chip, :date, :time,
                                    :prefecture, :municipalities, :area, :situation, :notification, :transferred,
                                    :location, :image)
  end
end
