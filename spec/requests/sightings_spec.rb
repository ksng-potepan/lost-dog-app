require 'rails_helper'

RSpec.describe 'Sightings' do
  let(:user) { create(:user) }
  let(:sighting) { create(:sighting, user:) }

  before do
    sign_in user
  end

  describe 'GET /sightings/new' do
    it '新規投稿画面の表示に成功すること' do
      get new_sighting_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /sightings' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post sightings_path, params: { sighting: attributes_for(:sighting) }
        expect(response).to have_http_status(:found)
      end

      it '新規投稿が登録されること' do
        expect do
          post sightings_path, params: { sighting: attributes_for(:sighting) }
        end.to change(Sighting, :count).by(1)
      end

      it 'リダイレクトすること' do
        post sightings_path, params: { sighting: attributes_for(:sighting) }
        expect(response).to redirect_to sightings_path
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post sightings_path, params: { sighting: attributes_for(:sighting, area: '') }
        expect(response).to have_http_status(:ok)
      end

      it '新規投稿されないこと' do
        expect do
          post sightings_path, params: { sighting: attributes_for(:sighting, area: '') }
        end.not_to change(Sighting, :count)
      end

      it 'エラーが表示されること' do
        post sightings_path, params: { sighting: attributes_for(:sighting, area: '') }
        expect(response.body).to include '場所を入力してください'
      end
    end
  end

  describe 'DELETE /sightings/:id' do
    it '投稿が削除されること' do
      delete sighting_path(sighting)
      expect(Sighting.find_by(id: sighting.id)).to be_nil
    end
  end

  describe 'GET /sightings/information' do
    it '注意書き画面の表示に成功すること' do
      get information_sightings_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /sightings/mysighting' do
    before do
      get mysighting_sightings_path
    end

    it '自分が投稿した一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '自分が投稿した目撃情報マップという文字が表示されること' do
      expect(response.body).to include '自分が投稿した目撃情報マップ'
    end
  end

  describe 'GET /sightings' do
    before do
      get sightings_path
    end

    it '投稿一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end
end
