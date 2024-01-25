require 'rails_helper'

RSpec.describe 'Users' do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe 'ユーザー新規登録について' do
    before do
      visit new_user_registration_path
    end

    context '正常に作成できる場合' do
      before do
        fill_in 'ユーザー名', with: 'test'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: '111111'
        fill_in '確認用パスワード', with: '111111'
        click_button '新規登録'
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content 'アカウント登録が完了しました。'
      end

      it 'root_pathに遷移すること' do
        expect(page).to have_current_path root_path
      end

      it 'ヘッダー内にマイページリンクがあること' do
        within('.header-menu') do
          expect(page).to have_content 'マイページ'
        end
      end
    end

    context '新規登録に失敗する場合' do
      it 'ユーザ名が未記入なこと' do
        fill_in 'ユーザー名', with: nil
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: '111111'
        fill_in '確認用パスワード', with: '111111'
        click_button '新規登録'
        expect(page).to have_content 'ユーザー名を入力してください'
      end

      it '重複したメールアドレスなこと' do
        fill_in 'ユーザー名', with: 'test'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '111111'
        fill_in '確認用パスワード', with: '111111'
        click_button '新規登録'
        expect(page).to have_content 'Eメールはすでに存在します'
      end
    end
  end

  describe 'ログインをクリック後について' do
    before do
      visit root_path
      within('.header-menu') do
        click_link 'ログイン'
      end
    end

    context '正常にログインできる場合' do
      before do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        within('.actions') do
          click_button 'ログイン'
        end
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content 'ログインしました。'
      end

      it 'user_path(user)に遷移すること' do
        expect(page).to have_current_path user_path(user)
      end

      it 'ヘッダー内にログアウトリンクがあること' do
        within('.header-menu') do
          expect(page).to have_content 'ログアウト'
        end
      end
    end

    context 'ログインに失敗する場合' do
      before do
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード', with: '123456'
        within('.actions') do
          click_button 'ログイン'
        end
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content 'Eメールまたはパスワードが違います。'
      end

      it 'ヘッダー内にログインリンクがあること' do
        within('.header-menu') do
          expect(page).to have_content 'ログイン'
        end
      end
    end
  end

  describe 'サインイン後' do
    before { sign_in(user) }

    describe 'パスワードの編集について' do
      before do
        visit edit_user_registration_path(user)
      end

      it '正常に編集できる場合' do
        fill_in '新しいパスワード', with: '111111'
        fill_in '確認用パスワード', with: '111111'
        fill_in '現在のパスワード', with: user.password
        click_button '更新する'
        expect(page).to have_current_path(user_path(user))
      end

      it '新しいパスワードが未記入で失敗する場合' do
        fill_in '新しいパスワード', with: nil
        fill_in '確認用パスワード', with: '111111'
        fill_in '現在のパスワード', with: user.password
        click_button '更新する'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it '現在のパスワードに正しくない値が記入され失敗する場合' do
        fill_in '新しいパスワード', with: '111111'
        fill_in '確認用パスワード', with: '111111'
        fill_in '現在のパスワード', with: '111222'
        click_button '更新する'
        expect(page).to have_content '現在のパスワードは不正な値です'
      end
    end

    describe 'プロフィールの編集について' do
      before do
        visit edit_user_path(user)
      end

      it '正常に編集できる場合' do
        fill_in 'ユーザー名', with: 'sample'
        fill_in 'メールアドレス', with: 'sample@example.com'
        click_button '更新する'
        expect(page).to have_current_path(user_path(user))
      end

      it 'ユーザ名が未記入で失敗する場合' do
        fill_in 'ユーザー名', with: nil
        fill_in 'メールアドレス', with: 'test@example.com'
        click_button '更新する'
        expect(page).to have_content '更新に失敗しました。'
      end
    end

    describe '画像アップロード機能について' do
      before do
        visit edit_user_path(user)
      end

      it '正常な画像ファイルをアップロードできること' do
        attach_file('image', 'spec/fixtures/sample.jpg')
        click_button '更新する'
        expect(page).to have_current_path(user_path(user))
      end

      it '画像ファイルをアップロードしなくても更新できること' do
        click_button '更新する'
        expect(page).to have_current_path(user_path(user))
      end
    end

    describe 'ログアウトをクリック後について' do
      before do
        visit root_path
        within('.header-menu') do
          click_link 'ログアウト'
        end
      end

      it '通知メッセージが表示されること' do
        expect(page).to have_content 'ログアウトしました。'
      end

      it 'root_pathに遷移すること' do
        expect(page).to have_current_path root_path
      end

      it 'ヘッダー内にログインリンクがあること' do
        within('.header-menu') do
          expect(page).to have_content 'ログイン'
        end
      end
    end
  end

  describe 'マイページについて' do
    context 'current_userがサインインしている場合' do
      before do
        sign_in user
        visit user_path(user)
      end

      it 'プロフィール編集先のリンクに遷移すること' do
        within('.account-table') do
          click_link 'プロフィール編集'
          expect(page).to have_current_path edit_user_path(user), ignore_query: true
        end
      end

      it '自分が投稿した迷子犬のリンクに遷移すること' do
        within('.box71') do
          click_link '迷子犬'
          expect(page).to have_current_path myamble_ambles_path, ignore_query: true
        end
      end

      it '自分が投稿した保護犬のリンクに遷移すること' do
        within('.box71') do
          click_link '保護犬'
          expect(page).to have_current_path myprotect_protects_path, ignore_query: true
        end
      end

      it 'ダイレクトメッセージの表示がないこと' do
        expect(page).not_to have_content 'ダイレクトメッセージ'
      end
    end

    context 'other_userがサインインしている場合' do
      before do
        sign_in other_user
        visit user_path(user)
      end

      it 'プロフィール編集先のリンクがないこと' do
        within('.account-table') do
          expect(page).not_to have_content 'プロフィール編集'
        end
      end

      it 'userが投稿した迷子犬のリンクに遷移すること' do
        click_link '迷子犬'
        expect(page).to have_current_path list_amble_path(user), ignore_query: true
      end

      it 'userが投稿した保護犬のリンクに遷移すること' do
        click_link '保護犬'
        expect(page).to have_current_path list_protect_path(user), ignore_query: true
      end

      it 'ダイレクトメッセージの表示があること' do
        expect(page).to have_content '連絡をする'
      end
    end
  end
end
