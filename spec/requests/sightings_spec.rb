require 'rails_helper'

RSpec.describe 'Sightings' do
  let(:user) { create(:user) }
  let(:sighting) { create(:sighting, user:) }
  let(:params) do
    {
      id: sighting.id,
      date: sighting.date,
      time: sighting.time,
      area: sighting.area,
      lat: sighting.lat,
      lng: sighting.lng
    }
  end

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

  describe 'GET /sightings/:id/edit' do
    before do
      get edit_sighting_path(sighting.id)
    end

    it '編集画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /sightings/update' do
    context 'パラメータが妥当な場合' do
      before do
        params = {
          sighting: {
            area: '大阪駅',
            lat: 34.7024,
            lng: 135.4959
          }
        }
        patch(sighting_path(sighting), params:)
        Sighting.find(sighting.id)
        sighting.reload
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:found)
      end

      it 'リダイレクトすること' do
        expect(response).to redirect_to sighting_path(sighting.id)
      end
    end

    context 'パラメータが不正な場合' do
      before do
        params = {
          sighting: {
            area: '',
            lat: nil,
            lng: nil
          }
        }
        patch(sighting_path(sighting), params:)
        Sighting.find(sighting.id)
        sighting.reload
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:ok)
      end

      it 'エラーが表示されること' do
        expect(response.body).to include '更新に失敗しました。'
      end
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

    context '検索した条件と一致する場合' do
      it '時間と一致する投稿が表示されること' do
        params[:search] = '正午'
        get '/sightings'
        expect(response.body).to include sighting.time
      end

      it '状況と一致する投稿が表示されること' do
        params[:search] = '走って行った'
        get '/sightings'
        expect(response.body).to include sighting.situation
      end

      it '迷子になった付近と一致する投稿が表示されること' do
        params[:search] = 'ハチ公前'
        get '/sightings'
        expect(response.body).to include sighting.area
      end

      it '日付で検索した場合、検索条件に一致するアムブルが表示されること' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/sightings'
        expect(response.body).to include sighting.date.strftime("%Y年%m月%d日")
      end
    end

    context '検索した条件と一致しない場合' do
      it '時間と一致する投稿が表示されること' do
        params[:search] = '正午'
        get '/sightings'
        expect(response.body).not_to include('朝')
      end

      it '状況と一致する投稿が表示されること' do
        params[:search] = '走って行った'
        get '/sightings'
        expect(response.body).not_to include('漁っていた')
      end

      it '迷子になった付近と一致する投稿が表示されること' do
        params[:search] = 'ハチ公前'
        get '/sightings'
        expect(response.body).not_to include('大阪市')
      end

      it '日付で検索した場合、検索条件に一致するアムブルが表示されないこと' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/sightings'
        within('.sightings-index') do
          expect(response.body).not_to include('2001年11月01日')
        end
      end
    end
  end
end
