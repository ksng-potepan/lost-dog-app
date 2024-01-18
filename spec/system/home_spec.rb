require 'rails_helper'

RSpec.describe 'Homes' do
  let(:user) { create(:user) }
  let!(:sighting) { create(:sighting, user:) }

  before do
    sign_in user
  end

  describe 'トップページ' do
    before do
      visit root_path
    end

    it 'インフォメーションへ遷移すること' do
      click_on 'こちら'
      expect(page).to have_current_path information_path, ignore_query: true
    end

    it '新着目撃情報が表示されていること' do
      expect(page).to have_content '新着目撃情報'
    end

    it '日時が表示されること' do
      expect(page).to have_content sighting.date.strftime("%Y年%m月%d日")
    end

    it '時間が表示されること' do
      expect(page).to have_content sighting.time
    end

    it '場所が表示されること' do
      expect(page).to have_content sighting.area
    end
  end

  describe 'インフォメーションページ' do
    before do
      visit information_path
    end

    it 'Amblesのインフォメーションへ遷移すること' do
      within('.top-information') do
        click_on '探しています'
        expect(page).to have_current_path information_ambles_path, ignore_query: true
      end
    end

    it 'Protectsのインフォメーションへ遷移すること' do
      within('.top-information') do
        click_on '保護しました'
        expect(page).to have_current_path information_protects_path, ignore_query: true
      end
    end

    it 'Sightingsのインフォメーションへ遷移すること' do
      within('.top-information') do
        click_on '目撃しました'
        expect(page).to have_current_path information_sightings_path, ignore_query: true
      end
    end
  end
end
