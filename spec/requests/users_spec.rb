require 'rails_helper'

RSpec.describe 'Users' do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe 'GET /users/sign_up' do
    it '新規登録画面の表示に成功すること' do
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:see_other)
      end

      it 'ユーザーが登録されること' do
        expect do
          post  user_registration_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトすること' do
        post user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: attributes_for(:user, username: '') }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post  user_registration_path, params: { user: attributes_for(:user, username: '') }
        end.not_to change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: attributes_for(:user, username: '') }
        expect(response.body).to include 'ユーザー名を入力してください'
      end
    end
  end

  describe 'GET /users/sign_in' do
    it 'ログイン画面の表示に成功すること' do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users/sign_in' do
    it '有効なユーザーでログインに成功すること' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to user_path(user)
    end

    it '無効なユーザーでログインに失敗すること' do
      post user_session_path, params: { email: 'invalid@example.com', password: 'password' }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'メールアドレスとパスワードが不正によりログインに失敗すること' do
      post user_session_path, params: { email: user.email, password: 'invalid_password' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /users/sign_out' do
    before do
      sign_in user
      delete destroy_user_session_path
    end

    it '正常にログアウトに成功すること' do
      expect(response).to redirect_to root_path
    end

    it 'リクエストが成功すること' do
      expect(response).to have_http_status(:see_other)
    end

    it 'user_idがnilであること' do
      expect(session[:user_id]).to be_falsey
    end
  end

  describe 'GET /users/:id' do
    before do
      sign_in user
      get user_path(user.id)
    end

    it 'マイページ画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it 'ユーザー名が表示されていること' do
      expect(response.body).to include user.username
    end

    it 'メールアドレスが表示されていること' do
      expect(response.body).to include user.email
    end

    it 'ダイレクトメッセージが表示されていないこと' do
      expect(response.body).not_to include "ダイレクトメッセージ"
    end

    it '異なるユーザーであればダイレクトメッセージが表示されていること' do
      sign_out user
      sign_in other_user
      get user_path(user.id)
      expect(response.body).to include "ダイレクトメッセージ"
    end
  end

  describe 'GET /users/edit' do
    before do
      sign_in user
      get edit_user_registration_path(user.id)
    end

    it 'パスワード編集画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:id/edit' do
    before do
      sign_in user
      get edit_user_path(user.id)
    end

    it 'プロフィール編集画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users/update' do
    before do
      sign_in user
    end

    context 'パラメータが妥当な場合' do
      before do
        params = {
          username: 'テストユーザー',
          email: 'test@example.com'
        }
        patch(user_path(user), params:)
        User.find(user.id)
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:found)
      end

      it 'リダイレクトすること' do
        expect(response).to redirect_to user_path(user.id)
      end
    end

    context 'パラメータが不正な場合' do
      before do
        params = {
          username: nil,
          email: 'test@example.com'
        }
        patch(user_path(user), params:)
        User.find(user.id)
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:ok)
      end

      it 'エラーが表示されること' do
        expect(response.body).to include '更新に失敗しました。'
      end
    end
  end

  describe 'DELETE /users' do
    before do
      sign_in user
    end

    it 'アカウントが削除されること' do
      expect do
        delete user_registration_path
      end.to change(User, :count).by -1
    end

    it 'リダイレクトすること' do
      delete user_registration_path
      expect(response).to redirect_to root_path
    end
  end
end
