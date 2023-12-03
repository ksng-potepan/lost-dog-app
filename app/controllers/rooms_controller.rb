class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    current_entries = current_user.entries
    my_room_id = []
    current_entries.each do |entry|
      my_room_id << entry.room.id
    end
    @another_entries = Entry.where(room_id: my_room_id).where.not(user_id: current_user.id)
  end

  def show
    @user = current_user
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
      @my_user = current_user.id
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @room = Room.create(user_id: current_user.id)
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(entry_params)
    redirect_to "/rooms/#{@room.id}"
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id).merge(room_id: @room.id)
  end
end
