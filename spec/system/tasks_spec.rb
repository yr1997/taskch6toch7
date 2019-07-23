require 'rails_helper'

describe 'タスク', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }

  shared_examples_for '作成済みのタスクが表示されている' do
    it { expect(page).to have_content 'テストを書く' }
  end

  before do
    # テストユーザーでログインする
    visit login_path
    fill_in 'メールアドレス', with: 'test1@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログインする'
  end

  describe '一覧機能' do
    context '一覧画面にアクセスしたとき' do
      before do
        # 一覧画面にアクセスする
        visit tasks_path
      end

      it_behaves_like '作成済みのタスクが表示されている'
    end
  end

  describe '詳細機能' do
    context '詳細画面にアクセスしたとき' do
      before do
        # 詳細画面にアクセスする
        visit task_path(task)
      end

      it_behaves_like '作成済みのタスクが表示されている'
    end
  end

  describe '新規作成' do
    before do
      # 新規作成画面にアクセスする
      visit new_task_path

      # 名称を入力する
      fill_in '名称', with: task_name
      # 登録ボタンを押下する
      click_button '登録する'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        # 正常に登録された旨のメッセージが表示される
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        # 名称が空という旨のエラーメッセージが表示されている
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end

  describe '削除' do
    context '一覧画面で削除リンクをクリックしたとき' do
      before do
        visit tasks_path
        accept_confirm { click_link '削除' }
      end

      it 'タスクが削除される' do
        # タスクが削除された旨のメッセージが表示されている
        expect(page).to have_selector '.alert-success', text: 'タスク「テストを書く」を削除しました。'
        # タスクのタイトルが表示されていない
        expect(find('table')).not_to have_content 'テストを書く'
      end
    end
  end
end
