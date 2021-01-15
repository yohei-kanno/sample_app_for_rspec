require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  
  let(:user){ create(:user) }
  let(:task){ create(:task,user: user) }
  
  include Login
  
  describe 'ログインしている場合' do
    before { sign_in user }
    describe '自分の作成したタスクの場合' do
      context 'タスクに入力値が有効である場合' do
        it 'タスクの作成が成功する事' do
          visit new_task_path
          fill_in "Title",  with: "test"
          fill_in "Content", with: "test"
          click_button 'Create Task'
          expect(page).to have_content("Task was successfully created.")
          expect(page).to have_content("test")
          expect(page).to have_content("test")
          expect(page).to have_content("todo")
        end
      end
      
      context 'タスクにタイトルが入力されていない事' do
        it 'タスクの登録に失敗する事' do
          visit new_task_path
          fill_in "Title",  with: nil
          fill_in "Content", with: "test"
          click_button 'Create Task'
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_content("1 error prohibited this task from being saved:")
        end
      end
      
      context '重複したタイトルが存在する事' do
        it 'タスクの登録に失敗する事' do
          task
          visit new_task_path
          fill_in "Title",  with: task.title
          fill_in "Content", with: task.content
          select task.status, from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content("Title has already been taken")
          expect(page).to have_content("1 error prohibited this task from being saved:")
        end
      end
      
      context '一覧画面' do
        it "編集と削除リンクがある事" do
          task
          visit tasks_path
          expect(page).to have_link("Edit")
          expect(page).to have_link("Destroy")
        end
      end
      
      context '編集画面' do
        it 'タスクの編集が成功する事' do
          visit edit_task_path(task)
          fill_in "Title",  with: task.title
          fill_in "Content", with: task.content
          select task.status, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content("Task was successfully updated.")
          expect(page).to have_content(task.title)
          expect(page).to have_content(task.content)
          expect(page).to have_content(task.status)
        end
      end
    end
    
    describe '他人の作成したタスクの場合' do
      let(:other_user){ create(:user) }
      let!(:other_task){ create(:task, user: other_user) }
      
      context '一覧画面' do
        it "編集と削除リンクが無い事" do
          visit tasks_path
          expect(page).to_not have_link("Edit")
          expect(page).to_not have_link("Destroy")
        end
      end
          
      context '編集画面' do
        it '編集画面への遷移に失敗する事' do
          visit edit_task_path(other_task)
          expect(current_path).to eq(root_path)
          expect(page).to have_content("Forbidden access.")
        end
      end
    end
  end
  
  describe 'ログインしていない場合' do
    context 'タスク新規作成画面' do
      it 'ログイン画面にリダイレクトされる事' do
        visit new_task_path
        expect(current_path).to eq(login_path)
        expect(page).to have_content("Login required")
      end
    end
    context 'タスク編集画面' do
      it 'ログイン画面にリダイレクトされる事' do
        visit edit_task_path(user)
        expect(current_path).to eq(login_path)
        expect(page).to have_content("Login required")
      end
    end
  end
end
