require 'rails_helper'

RSpec.describe 'Users', type: :system do
  
  let(:user){ create(:user) }
  let(:other_user){ create(:user) }
  let(:task){ create(:task,user: user) }
  
  include Login
  
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功すること' do
          visit  sign_up_path
          fill_in 'Email', with: "user@expample"
          fill_in 'Password', with: "foobar"
          fill_in 'Password confirmation', with: "foobar"
          click_button 'SignUp'
          expect(current_path).to eq(login_path)
          expect(page).to have_content("User was successfully created.")
        end
      end
      
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗すること' do
          visit  sign_up_path
          fill_in 'Email', with: nil
          fill_in 'Password', with: "foobar"
          fill_in 'Password confirmation', with: "foobar"
          click_button 'SignUp'
          expect(page).to have_content("Email can't be blank")
        end
      end
          
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗すること' do
          user
          visit  sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: "foobar"
          fill_in 'Password confirmation', with: "foobar"
          click_button 'SignUp'
          expect(page).to have_content("Email has already been taken")
        end
      end
    end
          
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗すること' do
          visit user_path(user)
          expect(current_path).to eq(login_path)
          expect(page).to have_content("Login required")
        end
      end
    end
  end


  describe 'ログイン後' do
    before do
      sign_in(user)
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功すること' do
          visit edit_user_path(user)
          fill_in 'Email',with: user.email
          click_button 'Update'
          expect(current_path).to eq(user_path(user))
          expect(page).to have_content("User was successfully updated.")
        end
      end
          
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗すること' do
          visit edit_user_path(user)
          fill_in 'Email',with: nil
          click_button 'Update'
          expect(page).to have_content("Email can't be blank")
        end
      end
        
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗すること' do
          visit edit_user_path(user)
          fill_in 'Email',with: other_user.email
          click_button 'Update'
          expect(page).to have_content("Email has already been taken")
        end
      end
      
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗すること' do
          visit edit_user_path(other_user)
          expect(current_path).to eq(user_path(user))
          expect(page).to have_content("Forbidden access.")
        end
      end
    end
    
    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示されること' do
          task
          visit user_path(user)
          expect(page).to have_content('You have 1 task.')
          expect(page).to have_content(task.title)
          expect(page).to have_content(task.status)
          expect(page).to have_link('Show')
          expect(page).to have_link('Edit')
          expect(page).to have_link('Destroy')
        end
      end
    end
  end
end
