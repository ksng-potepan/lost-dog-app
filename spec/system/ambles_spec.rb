require 'rails_helper'

RSpec.describe 'Ambles' do
  let(:user)       { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:amble)      { create(:amble, user:) }
  let(:other_amble) { create(:other_amble, user: other_user) }
  let(:expected) do
    %w[
      name
      breed
      size
      gender
      color
      age
      features
      tag
      chip
      date
      time
      prefecture
      municipalities
      area
      situation
      notification
    ]
  end

  before do
    sign_in user
  end

  describe '新規投稿ページ' do
    before do
      visit new_amble_path
    end

    context '正常に作成できる場合' do
      before do
        fill_in "amble_date", with: amble.date
        select amble.prefecture, from: 'amble_prefecture'
        fill_in 'amble_municipalities', with: amble.municipalities
        fill_in 'amble_name', with: amble.name
        choose 'amble_gender_unknown'
        choose 'amble_size_small'
        click_button '登録する'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content '新規作成しました。'
      end

      it 'amble_pathに遷移すること' do
        expect(page).to have_current_path amble_path(Amble.last)
      end
    end

    context '新規登録に失敗する場合' do
      it '日付けが未記入なこと' do
        fill_in 'amble_date', with: nil
        select amble.prefecture, from: 'amble_prefecture'
        fill_in 'amble_name', with: amble.name
        choose 'amble_gender_unknown'
        choose 'amble_size_small'
        click_button '登録する'
        expect(page).to have_content '日付を入力してください'
      end

      it '今日の日付より未来の日付を入力した場合、エラーメッセージが表示されること' do
        fill_in 'amble_date', with: (Time.zone.today + 1).to_s
        select amble.prefecture, from: 'amble_prefecture'
        fill_in 'amble_name', with: amble.name
        choose 'amble_gender_unknown'
        choose 'amble_size_small'
        click_button '登録する'
        expect(page).to have_content '日付は今日を含む前の日付を登録してください。'
      end
    end
  end

  describe '投稿編集ページ' do
    before do
      visit edit_amble_path(amble)
    end

    context '正常に更新できる場合' do
      before do
        fill_in "amble_date", with: amble.date
        select amble.prefecture, from: 'amble_prefecture'
        fill_in 'amble_name', with: 'Amble'
        choose 'amble_gender_unknown'
        choose 'amble_size_small'
        click_button '登録する'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content '更新しました。'
      end

      it 'amble_pathに遷移すること' do
        expect(page).to have_current_path amble_path(Amble.last)
      end
    end

    context '更新に失敗する場合' do
      it '名前が未記入なこと' do
        fill_in 'amble_date', with: amble.date
        select amble.prefecture, from: 'amble_prefecture'
        fill_in 'amble_name', with: nil
        choose 'amble_gender_unknown'
        choose 'amble_size_small'
        click_button '登録する'
        expect(page).to have_content '犬の名前を入力してください'
      end

      it '今日の日付より未来の日付を入力した場合、エラーメッセージが表示されること' do
        fill_in 'amble_date', with: (Time.zone.today + 1).to_s
        select amble.prefecture, from: 'amble_prefecture'
        fill_in 'amble_name', with: amble.name
        choose 'amble_gender_unknown'
        choose 'amble_size_small'
        click_button '登録する'
        expect(page).to have_content '日付は今日を含む前の日付を登録してください。'
      end
    end
  end

  describe '投稿詳細ページ' do
    before do
      visit amble_path(amble)
    end

    it 'ambleの値が取得できていること' do
      expected.each do |value|
        expect(page).to have_content amble[value] && ""
      end
    end

    context '自分の投稿の場合' do
      it '編集先のリンクに遷移すること' do
        within('.board-user') do
          click_link '編集する'
          expect(page).to have_current_path edit_amble_path(amble), ignore_query: true
        end
      end

      it '削除できambles_pathに遷移すること' do
        within('.board-user') do
          click_on '投稿を削除'
          expect(page).to have_current_path ambles_path, ignore_query: true
        end
      end
    end

    context '他人の投稿の場合' do
      before do
        sign_in other_user
        visit "/ambles/#{amble.id}"
      end

      it '投稿した人のユーザー名が表示されていること' do
        within('.board-user') do
          expect(page).to have_content amble.user.username
        end
      end

      it '編集先のリンクが表示されないこと' do
        within('.board-user') do
          expect(page).not_to have_link '編集する'
        end
      end
    end
  end

  describe '投稿一覧ページ' do
    before do
      visit ambles_path(amble)
    end

    it '犬の名前が正常に表示されること' do
      within('.index') do
        expect(page).to have_content amble.name
      end
    end

    it '迷子の日付けが正常に表示されること' do
      within('.index') do
        expect(page).to have_content amble.date.strftime("%Y年%m月%d日")
      end
    end

    it '迷子の場所が正常に表示されること' do
      within('.index') do
        expect(page).to have_content amble.prefecture
      end
    end

    it '迷子の状況が正常に表示されること' do
      within('.index') do
        expect(page).to have_content amble.situation
      end
    end

    it '投稿日時が正常に表示されること' do
      within('.index') do
        expect(page).to have_content amble.created_at.strftime("%Y年%m月%d日")
      end
    end

    it "詳細へのリンクが貼られていること" do
      expect(page).to have_link amble.name
    end

    it '詳細へのリンクをクリックすると詳細ページに遷移すること' do
      click_on amble.name
      expect(page).to have_current_path amble_path(amble), ignore_query: true
    end
  end

  describe '自分の投稿一覧ページ' do
    before do
      visit myamble_ambles_path(amble)
    end

    it '自分の投稿が表示できること' do
      expect(page).to have_content amble.name
    end

    it '他人の投稿が表示できないこと' do
      expect(page).not_to have_content other_amble.name
    end
  end

  describe 'ステップフォーム', js: true do
    before do
      visit new_amble_path
      sleep 10
    end

    it 'フォームが表示されていることを確認' do
      expect(page).to have_css('#form_amble')
    end

    it '「次へ」ボタンをクリックでフォームが進むこと' do
      find_by_id('form_next').click
      element = find('.form_area').native.css_value('margin-left')
      expect(element).to eq('-1400px')
    end

    it '「戻る」ボタンをクリックでファームが戻ること' do
      find_by_id('form_next').click
      find_by_id('back').click
      element = find('.form_area').native.css_value('margin-left')
      expect(element).to eq('0px')
    end
  end
end
