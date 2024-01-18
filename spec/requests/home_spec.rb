require 'rails_helper'

RSpec.describe 'Homes' do
  let(:user) { create(:user) }
  let!(:sighting) { create(:sighting, user:) }
  let!(:sightings) do
    create_list(:sighting, 4, user:).map.with_index(1) do |sighting, i|
      sighting.date = Time.zone.today - (i * 3)
      sighting.save!
      sighting
    end
  end
  let(:sightings_count) { 0 }

  describe 'GET/top' do
    before do
      get root_path
    end

    it 'トップページが表示に成功すること' do
      expect(response).to have_http_status(:ok)
    end

    it '新着目撃情報が表示されていること' do
      expect(response.body).to include '新着目撃情報'
    end

    it '時間が表示されること' do
      expect(response.body).to include sighting.time
    end

    it '場所が表示されること' do
      expect(response.body).to include sighting.area
    end

    it '日付が取得されていること' do
      sightings[1..3].all? do |sighting|
        expect(response.body).to include sighting.date.strftime("%Y年%m月%d日")
      end
    end

    it '4個目の情報が取得されないこと' do
      expect(response.body).not_to include sightings[sightings_count].date.strftime("%Y年%m月%d日")
    end
  end

  describe 'GET /ambles/information' do
    it '注意書き画面の表示に成功すること' do
      sign_in user
      get information_path
      expect(response).to have_http_status(:ok)
    end

    it 'サインイン前の場合、画面の表示に失敗すること' do
      get information_path
      expect(response).to have_http_status(:found)
    end
  end
end
