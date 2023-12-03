require 'rails_helper'

RSpec.describe 'Rooms' do
  let(:user)       { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:room) { Room.create(user_id: user.id) }

  before do
    sign_in user

    Entry.create(room_id: room.id, user_id: user.id)
    Entry.create(room_id: room.id, user_id: other_user.id)
    message = Message.new(room_id: room.id, user_id: user.id, message: "こんにちは")
    message.save
  end

  describe '投稿詳細ページ' do
    before do
      visit room_path(room)
    end

    it 'DM一覧ページのリンクに遷移すること' do
      click_link('rooms')
      expect(page).to have_current_path rooms_path(room), ignore_query: true
    end

    it 'DMの相手の名前が表示されること' do
      expect(page).to have_content other_user.username
    end

    it '相手の名前をクリックしてプロフィールに遷移すること' do
      click_on other_user.username
      expect(page).to have_current_path user_path(other_user), ignore_query: true
    end

    it 'メッセージが表示されること' do
      within('.dm-message') do
        expect(page).to have_content 'こんにちは'
      end
    end

    it 'メッセージを追加で送れること' do
      fill_in 'メッセージを入力して下さい', with: 'テストメッセージ'
      click_button '送信'
      expect(page).to have_content 'テストメッセージ'
    end
  end

  describe '投稿一覧ページ' do
    before do
      visit rooms_path(room)
    end

    it 'トーク一覧が表示されること' do
      expect(page).to have_content 'トーク一覧'
    end

    it '相手のユーザー名が表示されること' do
      expect(page).to have_content other_user.username
    end

    it '最後のメッセージが表示されること' do
      expect(page).to have_content 'こんにちは'
    end

    it 'ユーザー名をクリックすると詳細ページに遷移すること' do
      click_on other_user.username
      expect(page).to have_current_path room_path(room), ignore_query: true
    end
  end
end
