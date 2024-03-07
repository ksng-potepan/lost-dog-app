require 'rails_helper'

RSpec.describe 'Sightings' do
  let(:user) { create(:user) }
  let(:sighting) { create(:sighting, user:) }

  before do
    sign_in user
  end

  describe '新規投稿ページ' do
    before do
      visit new_sighting_path
    end

    context '正常に作成できる場合' do
      before do
        fill_in "sighting_area", with: sighting.area
        fill_in "sighting_date", with: sighting.date
        find_by_id('lat', visible: false).set(sighting.lat)
        click_button '登録する'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content '新規作成しました。'
      end

      it 'sightings_pathに遷移すること' do
        expect(page).to have_current_path sightings_path
      end
    end

    context '新規登録に失敗する場合' do
      it '日付けが未記入なこと' do
        fill_in "sighting_area", with: sighting.area
        fill_in "sighting_date", with: nil
        find_by_id('lat', visible: false).set(sighting.lat)
        click_button '登録する'
        expect(page).to have_content '日付を入力してください'
      end

      it '今日の日付より未来の日付を入力した場合、エラーメッセージが表示されること' do
        fill_in "sighting_date", with: sighting.date
        fill_in 'sighting_date', with: (Time.zone.today + 1).to_s
        find_by_id('lat', visible: false).set(sighting.lat)
        click_button '登録する'
        expect(page).to have_content '日付は今日を含む前の日付を登録してください。'
      end

      it 'マップにピンを刺さない事により経度が０なこと' do
        fill_in "sighting_area", with: sighting.area
        fill_in "sighting_date", with: sighting.date
        find_by_id('lat', visible: false).set(0)
        click_button '登録する'
        expect(page).to have_content 'マーカーを立ててください'
      end
    end
  end

  describe '投稿編集ページ' do
    before do
      visit edit_sighting_path(sighting)
    end

    context '正常に更新できる場合' do
      before do
        fill_in "sighting_date", with: sighting.date
        fill_in 'sighting_area', with: '大阪駅'
        find_by_id('lat', visible: false).set(34.7024)
        find_by_id('lng', visible: false).set(135.4959)
        click_button '登録する'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content '更新しました。'
      end

      it 'amble_pathに遷移すること' do
        expect(page).to have_current_path sighting_path(Sighting.last)
      end
    end

    context '更新に失敗する場合' do
      it '場所が未記入なこと' do
        fill_in "sighting_date", with: sighting.date
        fill_in 'sighting_area', with: ''
        find_by_id('lat', visible: false).set(nil)
        find_by_id('lng', visible: false).set(nil)
        click_button '登録する'
        expect(page).to have_content 'マーカーを立ててください'
      end

      it '今日の日付より未来の日付を入力した場合、エラーメッセージが表示されること' do
        fill_in 'sighting_date', with: (Time.zone.today + 1).to_s
        fill_in "sighting_area", with: sighting.area
        find_by_id('lat', visible: false).set(sighting.lat)
        click_button '登録する'
        expect(page).to have_content '日付は今日を含む前の日付を登録してください。'
      end
    end
  end

  describe '投稿一覧ページ' do
    before do
      visit sightings_path(sighting)
    end

    it '目撃情報マップの文言が正常に表示されること' do
      expect(page).to have_content "目撃情報マップ"
    end

    it 'マップが表示されること' do
      expect(page).to have_css("#map")
    end

    it '日付けが正常に表示されること' do
      first(".sighting-index") do
        expect(page).to have_content sighting.date.strftime("%Y年%m月%d日")
      end
    end

    it '場所が正常に表示されること' do
      first(".sighting-index") do
        expect(page).to have_content sighting.area
      end
    end

    it '状況が正常に表示されること' do
      first(".sighting-index") do
        expect(page).to have_content sighting.situation
      end
    end

    it '投稿日時が正常に表示されること' do
      within('.sighting-index') do
        expect(page).to have_content sighting.created_at.strftime("%Y/%m/%d %H:%M")
      end
    end

    it "詳細へのリンクが貼られていること" do
      within('.sighting-index') do
        expect(page).to have_link sighting.date.strftime("%Y年%m月%d日")
      end
    end

    it '詳細へのリンクをクリックすると詳細ページに遷移すること' do
      within('.sighting-index') do
        click_on sighting.date.strftime("%Y年%m月%d日")
        expect(page).to have_current_path sighting_path(sighting), ignore_query: true
      end
    end
  end

  describe '投稿詳細ページ' do
    before do
      visit sighting_path(sighting)
    end

    it '目撃情報マップの文言が正常に表示されること' do
      expect(page).to have_content "目撃情報マップ"
    end

    it 'マップが表示されること' do
      expect(page).to have_css("#map")
    end

    it '日付けが正常に表示されること' do
      expect(page).to have_content sighting.date.strftime("%Y年%m月%d日")
    end

    it '場所が正常に表示されること' do
      expect(page).to have_content sighting.area
    end

    it '状況が正常に表示されること' do
      expect(page).to have_content sighting.situation
    end

    it '削除ボタンがあること' do
      expect(page).to have_button '投稿を削除'
    end
  end
end
