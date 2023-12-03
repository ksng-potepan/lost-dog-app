require 'rails_helper'

RSpec.describe 'Rooms' do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  before do
    sign_in user
  end

  describe 'POST /rooms' do
    it 'リクエストが成功すること' do
      post rooms_path, params: { entry: { user_id: other_user.id } }
      expect(response).to have_http_status(:found)
    end

    it 'ルームが登録されること' do
      post rooms_path, params: { entry: { user_id: other_user.id } }
      expect(Room.count).to eq(1)
    end

    it 'エントリーが登録されること' do
      post rooms_path, params: { entry: { user_id: other_user.id } }
      expect(Entry.count).to eq(2)
    end

    it 'リダイレクトすること' do
      post rooms_path, params: { entry: { user_id: other_user.id } }
      expect(response).to redirect_to room_path(Room.last.id)
    end
  end

  describe 'GET /rooms/:id' do
    before do
      room = Room.create(user_id: user.id)
      Entry.create(room_id: room.id, user_id: user.id)
      Entry.create(room_id: room.id, user_id: other_user.id)
      message = Message.new(room_id: room.id, user_id: user.id, message: "こんにちは")
      message.save

      get room_path(room.id)
    end

    it 'room画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it 'ユーザー名が表示されていること' do
      expect(response.body).to include other_user.username
    end

    it 'メッセージが表示されていること' do
      expect(response.body).to include "こんにちは"
    end
  end

  describe 'GET /rooms' do
    before do
      room = Room.create(user_id: user.id)
      Entry.create(room_id: room.id, user_id: user.id)
      Entry.create(room_id: room.id, user_id: other_user.id)
      message = Message.new(room_id: room.id, user_id: user.id, message: "こんにちは")
      message.save

      get rooms_path(room)
    end

    it 'DM一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '作成されたルームが表示されること' do
      expect(response.body).to include(other_user.username)
    end

    it 'メッセージが表示されていること' do
      expect(response.body).to include "こんにちは"
    end
  end
end
