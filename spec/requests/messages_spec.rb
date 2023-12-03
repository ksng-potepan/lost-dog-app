require 'rails_helper'

RSpec.describe 'Messages' do
  let(:user) { create(:user) }

  describe 'POST /messages' do
    before do
      sign_in user
      room = Room.create(user_id: user.id)
      post messages_path, params: { message: { room_id: room.id, message: 'テストメッセージ' } }
    end

    it 'リクエストが成功すること' do
      expect(response).to have_http_status(:found)
    end

    it 'メッセージが登録されること' do
      expect(Message.count).to eq(1)
    end

    it 'リダイレクトすること' do
      expect(response).to redirect_to room_path(Room.last)
    end
  end
end
