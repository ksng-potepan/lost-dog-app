require 'rails_helper'

RSpec.describe 'Protects' do
  let(:user) { create(:user) }
  let(:protect) { create(:protect, user:) }
  let(:transferred_protect) { create(:transferred_protect, user:) }
  let(:params) do
    {
      id: protect.id,
      situation: protect.situation,
      prefecture: protect.prefecture,
      size: protect.size,
      gender: protect.gender,
      date: protect.date
    }
  end

  before do
    sign_in user
  end

  describe 'GET /protects/new' do
    it '新規投稿画面の表示に成功すること' do
      get new_protect_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /protects' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post protects_path, params: { protect: attributes_for(:protect) }
        expect(response).to have_http_status(:found)
      end

      it '新規投稿が登録されること' do
        expect do
          post protects_path, params: { protect: attributes_for(:protect) }
        end.to change(Protect, :count).by(1)
      end

      it 'リダイレクトすること' do
        post protects_path, params: { protect: attributes_for(:protect) }
        expect(response).to redirect_to protect_path(Protect.last)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post protects_path, params: { protect: attributes_for(:protect, date: '') }
        expect(response).to have_http_status(:ok)
      end

      it '新規投稿されないこと' do
        expect do
          post protects_path, params: { protect: attributes_for(:protect, date: '') }
        end.not_to change(Protect, :count)
      end

      it 'エラーが表示されること' do
        post protects_path, params: { protect: attributes_for(:protect, date: '') }
        expect(response.body).to include '日付を入力してください'
      end
    end
  end

  describe 'DELETE /portects/:id' do
    it '投稿が削除されること' do
      delete protect_path(protect)
      expect(Protect.find_by(id: protect.id)).to be_nil
    end
  end

  describe 'GET /protects/:id' do
    before do
      get protect_path(protect.id)
    end

    it 'マイページ画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '日付けが表示されていること' do
      expect(response.body).to include protect.date.strftime("%Y年%m月%d日")
    end

    it '名前が表示されていること' do
      expect(response.body).to include protect.name
    end

    it '都道府県が表示されていること' do
      expect(response.body).to include protect.prefecture
    end

    it '性別が表示されていること' do
      expect(Capybara.string(response.body)).to be_has_css '.fa-genderless'
    end

    it '大きさが表示されていること' do
      expect(response.body).to include protect.size
    end
  end

  describe 'GET /protects/:id/edit' do
    before do
      get edit_protect_path(protect.id)
    end

    it '編集画面の表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /protects/update' do
    context 'パラメータが妥当な場合' do
      before do
        params = {
          protect: {
            situation: '移動中に'
          }
        }
        patch(protect_path(protect), params:)
        Protect.find(protect.id)
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:found)
      end

      it 'リダイレクトすること' do
        expect(response).to redirect_to protect_path(protect.id)
      end
    end

    context 'パラメータが不正な場合' do
      before do
        params = {
          protect: {
            situation: nil
          }
        }
        patch(protect_path(protect), params:)
        Protect.find(protect.id)
      end

      it 'リクエストが成功すること' do
        expect(response).to have_http_status(:ok)
      end

      it 'エラーが表示されること' do
        expect(response.body).to include '更新に失敗しました。'
      end
    end
  end

  describe 'GET /protects/information' do
    it '注意書き画面の表示に成功すること' do
      get information_protects_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /protects/myprotect' do
    before do
      get myprotect_protects_path
    end

    it '自分が投稿した一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '自分の投稿一覧という文字が表示されること' do
      expect(response.body).to include '自分の投稿一覧'
    end
  end

  describe 'GET /protects' do
    before do
      get protects_path
    end

    it '投稿一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    context '検索した条件と一致する場合' do
      it '名前と一致する投稿が表示されること' do
        params[:search] = 'Protect'
        get '/protects'
        within('.index') do
          expect(response.body).to include protect.name
        end
      end

      it '都道府県と一致する投稿が表示されること' do
        params[:prefecture] = '北海道'
        get '/protects'
        within('.index') do
          expect(response.body).to include protect.prefecture
        end
      end

      it '市町村と一致する投稿が表示されること' do
        params[:search] = '札幌市'
        get '/protects'
        expect(response.body).to include protect.municipalities
      end

      it '迷子になった付近と一致する投稿が表示されること' do
        params[:search] = '札幌駅前'
        get '/protects'
        expect(response.body).to include protect.area
      end

      it 'サイズと一致する投稿が表示されること' do
        params[:size] = '小型犬'
        get '/protects'
        within('.index') do
          expect(response.body).to include protect.size
        end
      end

      it '日付で検索した場合、検索条件に一致する投稿が表示されること' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/protects'
        within('.index') do
          expect(response.body).to include protect.date.strftime("%Y年%m月%d日")
        end
      end
    end

    context '検索した条件と一致しない場合' do
      it '名前と一致しない投稿が表示されないこと' do
        params[:search] = 'Protect'
        get '/protects'
        within('.index') do
          expect(response.body).not_to include('猫ちゃん')
        end
      end

      it '都道府県と一致しない投稿が表示されないこと' do
        params[:prefecture] = '北海道'
        get '/protects'
        within('.index') do
          expect(response.body).not_to include('大阪府')
        end
      end

      it '市町村と一致しない投稿が表示されないこと' do
        params[:search] = '札幌市'
        get '/protects'
        expect(response.body).not_to include('大阪市')
      end

      it '迷子になった付近と一致しない投稿が表示されないこと' do
        params[:search] = '札幌駅前'
        get '/protects'
        expect(response.body).not_to include('梅田駅前')
      end

      it 'サイズと一致しない投稿が表示されないこと' do
        params[:size] = '小型犬'
        get '/protects'
        within('.index') do
          expect(response.body).not_to include('大型犬')
        end
      end

      it '日付で検索した場合、検索条件に一致する投稿が表示されること' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/protects'
        within('.index') do
          expect(response.body).not_to include('2001年11月01日')
        end
      end
    end
  end

  describe 'GET /protects/transferred' do
    before do
      get transferred_protects_path, params: { transferred: true }
    end

    it 'transferredがtrueのみを投稿一覧ページの表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    context '検索した条件と一致する場合' do
      it '名前と一致する投稿が表示されること' do
        params[:search] = 'ferred'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).to include transferred_protect.name
        end
      end

      it '都道府県と一致する投稿が表示されること' do
        params[:prefecture] = '東京都'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).to include transferred_protect.prefecture
        end
      end

      it '市町村と一致する投稿が表示されること' do
        params[:search] = '札幌市'
        get '/protects'
        expect(response.body).to include protect.municipalities
      end

      it '迷子になった付近と一致する投稿が表示されること' do
        params[:search] = '札幌駅前'
        get '/protects'
        expect(response.body).to include protect.area
      end

      it 'サイズと一致する投稿が表示されること' do
        params[:size] = '小型犬'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).to include transferred_protect.size
        end
      end

      it '日付で検索した場合、検索条件に一致する投稿が表示されること' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12/31'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).to include transferred_protect.date.strftime("%Y年%m月%d日")
        end
      end
    end

    context '検索した条件と一致しない場合' do
      it '名前と一致しない投稿が表示されないこと' do
        params[:search] = 'Protect'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).not_to include('猫ちゃん')
        end
      end

      it '都道府県と一致しない投稿が表示されないこと' do
        params[:prefecture] = '北海道'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).not_to include('大阪府')
        end
      end

      it '市町村と一致しない投稿が表示されないこと' do
        params[:search] = '札幌市'
        get '/protects'
        expect(response.body).not_to include('大阪市')
      end

      it '迷子になった付近と一致しない投稿が表示されないこと' do
        params[:search] = '札幌駅前'
        get '/protects'
        expect(response.body).not_to include('梅田駅前')
      end

      it 'サイズと一致しない投稿が表示されないこと' do
        params[:size] = '小型犬'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).not_to include('大型犬')
        end
      end

      it '日付で検索した場合、検索条件に一致する投稿が表示されること' do
        params[:start_date] = '2000/01/01'
        params[:end_date] = '2000/12//31'
        get '/protects/transferred'
        within('.index') do
          expect(response.body).not_to include('2001年11月01日')
        end
      end
    end
  end
end
