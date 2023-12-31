require 'rails_helper'

RSpec.describe 'Protects' do
  let(:user)       { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:protect)      { create(:protect, user:) }
  let(:transferred_protect) { create(:transferred_protect, user: other_user) }
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
      visit new_protect_path
    end

    context '正常に作成できる場合' do
      before do
        fill_in "protect_date", with: protect.date
        select protect.prefecture, from: 'protect_prefecture'
        fill_in 'protect_situation', with: protect.situation
        choose 'protect_gender_unknown'
        choose 'protect_size_small'
        click_button '登録する'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content '新規作成しました。'
      end

      it 'amble_pathに遷移すること' do
        expect(page).to have_current_path protect_path(Protect.last)
      end
    end

    context '新規登録に失敗する場合' do
      it '日付けが未記入なこと' do
        fill_in 'protect_date', with: nil
        select protect.prefecture, from: 'protect_prefecture'
        fill_in 'protect_name', with: protect.name
        choose 'protect_gender_unknown'
        choose 'protect_size_small'
        click_button '登録する'
        expect(page).to have_content '日付けを入力してください'
      end

      it '今日の日付より未来の日付を入力した場合、エラーメッセージが表示されること' do
        fill_in 'protect_date', with: (Time.zone.today + 1).to_s
        select protect.prefecture, from: 'protect_prefecture'
        fill_in 'protect_name', with: protect.name
        choose 'protect_gender_unknown'
        choose 'protect_size_small'
        click_button '登録する'
        expect(page).to have_content '日付けは今日を含む前の日付を登録してください。'
      end
    end
  end

  describe '投稿編集ページ' do
    before do
      visit edit_protect_path(protect)
    end

    context '正常に更新できる場合' do
      before do
        fill_in "protect_date", with: protect.date
        select protect.prefecture, from: 'protect_prefecture'
        fill_in 'protect_name', with: 'Protect-dog'
        choose 'protect_gender_unknown'
        choose 'protect_size_small'
        click_button '登録する'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content '更新しました。'
      end

      it 'protect_pathに遷移すること' do
        expect(page).to have_current_path protect_path(Protect.last)
      end
    end

    context '更新に失敗する場合' do
      it '状況が未記入なこと' do
        fill_in 'protect_date', with: protect.date
        select protect.prefecture, from: 'protect_prefecture'
        fill_in 'protect_situation', with: nil
        choose 'protect_gender_unknown'
        choose 'protect_size_small'
        click_button '登録する'
        expect(page).to have_content '状況を入力してください'
      end

      it '今日の日付より未来の日付を入力した場合、エラーメッセージが表示されること' do
        fill_in 'protect_date', with: (Time.zone.today + 1).to_s
        select protect.prefecture, from: 'protect_prefecture'
        fill_in 'protect_name', with: protect.name
        choose 'protect_gender_unknown'
        choose 'protect_size_small'
        click_button '登録する'
        expect(page).to have_content '日付けは今日を含む前の日付を登録してください。'
      end
    end
  end

  describe '投稿詳細ページ' do
    before do
      visit protect_path(protect)
    end

    it 'protectの値が取得できていること' do
      expected.each do |value|
        expect(page).to have_content protect[value] && ""
      end
    end

    context '自分の投稿の場合' do
      it '編集先のリンクに遷移すること' do
        within('.amble-user') do
          click_link '編集する'
          expect(page).to have_current_path edit_protect_path(protect), ignore_query: true
        end
      end

      it '解決したリンクで削除しprotects_pathに遷移すること' do
        within('.amble-user') do
          click_on '解決しました'
          expect(page).to have_current_path protects_path, ignore_query: true
        end
      end

      it '削除できprotects_pathに遷移すること' do
        within('.amble-user') do
          click_on '投稿を削除'
          expect(page).to have_current_path protects_path, ignore_query: true
        end
      end
    end

    context '他人の投稿の場合' do
      before do
        sign_in other_user
        visit "/protects/#{protect.id}"
      end

      it '投稿した人のユーザー名が表示されていること' do
        within('.amble-user') do
          expect(page).to have_content protect.user.username
        end
      end

      it '編集先のリンクが表示されないこと' do
        within('.amble-user') do
          expect(page).not_to have_link '編集する'
        end
      end
    end
  end

  describe '投稿一覧ページ' do
    before do
      visit protects_path(protect)
    end

    it '名前が正常に表示されること' do
      within('.index') do
        expect(page).to have_content protect.name
      end
    end

    it '保護した日付けが正常に表示されること' do
      within('.index') do
        expect(page).to have_content protect.date.strftime("%Y年%m月%d日")
      end
    end

    it '保護した場所が正常に表示されること' do
      within('.index') do
        expect(page).to have_content protect.prefecture
      end
    end

    it '保護した状況が正常に表示されること' do
      within('.index') do
        expect(page).to have_content protect.situation
      end
    end

    it '投稿日時が正常に表示されること' do
      within('.index') do
        expect(page).to have_content protect.created_at.strftime("%Y年%m月%d日")
      end
    end

    it "詳細へのリンクが貼られていること" do
      expect(page).to have_link protect.user.username
    end

    it '詳細へのリンクをクリックすると詳細ページに遷移すること' do
      click_on protect.user.username
      expect(page).to have_current_path protect_path(protect), ignore_query: true
    end
  end

  describe '自分の投稿一覧ページ' do
    before do
      visit myprotect_protects_path(protect)
    end

    it '自分の投稿が表示できること' do
      expect(page).to have_content protect.name
    end

    it '他人の投稿が表示できないこと' do
      expect(page).not_to have_content transferred_protect.name
    end
  end

  describe 'transferred一覧ページ' do
    before do
      visit transferred_protects_path(transferred_protect)
    end

    it 'trueのみが表示できること' do
      expect(page).to have_content transferred_protect.location
    end

    it 'falseの投稿が表示されないこと' do
      expect(Protect.where(transferred: false).count).to eq(0)
    end
  end
end
