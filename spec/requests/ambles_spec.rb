require 'rails_helper'

RSpec.describe 'Ambles' do
  let(:user)  { create(:user) }
  let(:amble) { create(:amble, user:) }
  let(:params) do
    {
      id: amble.id,
      name: amble.name,
      prefecture: amble.prefecture,
      size: amble.size,
      date: amble.date
    }
  end

  before do
    sign_in user
  end

  describe 'GET /ambles/new' do
    it '新規投稿画面の表示に成功すること' do
      get new_amble_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /ambles' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post ambles_path, params: { amble: attributes_for(:amble) }
        expect(response).to have_http_status(:found)
      end

      it '新規投稿が登録されること' do
        expect do
          post ambles_path, params: { amble: attributes_for(:amble) }
        end.to change(Amble, :count).by(1)
      end

      it 'リダイレクトすること' do
        post ambles_path, params: { amble: attributes_for(:amble) }
        expect(response).to redirect_to amble_path(Amble.last)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post ambles_path, params: { amble: attributes_for(:amble, name: '') }
        expect(response).to have_http_status(:ok)
      end

      it '新規投稿されないこと' do
        expect do
          post ambles_path, params: { amble: attributes_for(:amble, name: '') }
        end.not_to change(Amble, :count)
      end

      it 'エラーが表示されること' do
        post ambles_path, params: { amble: attributes_for(:amble, name: '') }
        expect(response.body).to include '犬の名前を入力してください'
      end
    end
  end

  describe 'DELETE /ambles/:id' do
    it '投稿が削除されること' do
      delete amble_path(amble)
      expect(Amble.find_by(id: amble.id)).to be_nil
    end
  end

  describe 'GET /ambles/:id' do
    before do
      get amble_path(amble.id)
    end

    it 'マイページ画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '日付けが表示されていること' do
      expect(response.body).to include amble.date.strftime("%Y年%m月%d日")
    end

    it 'ユーザー名が表示されていること' do
      expect(response.body).to include amble.name
    end

    it '都道府県が表示されていること' do
      expect(response.body).to include amble.prefecture
    end

    it '性別が表示されていること' do
      expect(Capybara.string(response.body)).to be_has_css '.fa-genderless'
    end

    it '大きさが表示されていること' do
      expect(response.body).to include amble.size
    end
  end

  describe 'GET /ambles/:id/edit' do
    before do
      get edit_amble_path(amble.id)
    end

    it 'プロフィール編集画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /ambles/update' do
    context 'パラメータが妥当な場合' do
      before do
        params = {
          amble: {
            name: 'amble'
          }
        }
        patch(amble_path(amble), params:)
        Amble.find(amble.id)
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:found)
      end

      it 'リダイレクトすること' do
        expect(response).to redirect_to amble_path(amble.id)
      end
    end

    context 'パラメータが不正な場合' do
      before do
        params = {
          amble: {
            name: nil
          }
        }
        patch(amble_path(amble), params:)
        Amble.find(amble.id)
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:ok)
      end

      it 'エラーが表示されること' do
        expect(response.body).to include '更新に失敗しました。'
      end
    end
  end

  describe 'GET /ambles/information' do
    it '注意書き画面の表示に成功すること' do
      get information_ambles_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /ambles/myamble' do
    before do
      get myamble_ambles_path
    end

    it '自分が投稿した一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '自分の投稿一覧という文字が表示されること' do
      expect(response.body).to include '自分の投稿一覧'
    end
  end

  describe 'GET /ambles' do
    before do
      get ambles_path
    end

    it '投稿一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    context '検索した条件と一致する場合' do
      it '名前と一致する投稿が表示されること' do
        params[:search] = 'Amble'
        get '/ambles'
        expect(response.body).to include amble.name
      end

      it '都道府県と一致する投稿が表示されること' do
        params[:prefecture] = '東京都'
        get '/ambles'
        expect(response.body).to include amble.prefecture
      end

      it '市町村と一致する投稿が表示されること' do
        params[:search] = '渋谷区'
        get '/ambles'
        expect(response.body).to include amble.municipalities
      end

      it '迷子になった付近と一致する投稿が表示されること' do
        params[:search] = '渋谷駅前'
        get '/ambles'
        expect(response.body).to include amble.area
      end

      it 'サイズと一致する投稿が表示されること' do
        params[:size] = '小型犬'
        get '/ambles'
        within('.index') do
          expect(response.body).to include amble.size
        end
      end

      it '性別と一致する投稿が表示されること' do
        params[:size] = '不明'
        get '/ambles'
        within('.index') do
          expect(response.body).to include amble.gender
        end
      end

      it '日付で検索した場合、検索条件に一致するアムブルが表示されること' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/ambles'
        expect(response.body).to include amble.date.strftime("%Y年%m月%d日")
      end
    end

    context '検索した条件と一致しない場合' do
      it '名前と一致しない投稿が表示されないこと' do
        params[:search] = 'Amble'
        get '/ambles'
        within('.index') do
          expect(response.body).not_to include('猫ちゃん')
        end
      end

      it '都道府県と一致しない投稿が表示されないこと' do
        params[:prefecture] = '東京都'
        get '/ambles'
        within('.index') do
          expect(response.body).not_to include('大阪府')
        end
      end

      it '市町村と一致しない投稿が表示されないこと' do
        params[:search] = '渋谷区'
        get '/ambles'
        expect(response.body).not_to include('大阪市')
      end

      it '迷子になった付近と一致しない投稿が表示されないこと' do
        params[:search] = '渋谷駅前'
        get '/ambles'
        expect(response.body).not_to include('梅田駅前')
      end

      it 'サイズと一致しない投稿が表示されないこと' do
        params[:size] = '小型犬'
        get '/ambles'
        within('.index') do
          expect(response.body).not_to include('大型犬')
        end
      end

      it '性別と一致しない投稿が表示されないこと' do
        params[:gender] = '不明'
        get '/ambles'
        within('.index') do
          expect(response.body).not_to include('オス')
        end
      end

      it '日付で検索した場合、検索条件に一致するアムブルが表示されないこと' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/ambles'
        within('.index') do
          expect(response.body).not_to include('2001年11月01日')
        end
      end
    end
  end
end
