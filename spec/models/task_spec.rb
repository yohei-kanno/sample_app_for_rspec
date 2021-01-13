require 'rails_helper'

RSpec.describe Task, type: :model do
  
  describe "タスクモデルのバリデーションテスト" do
    
    it "[有効]タスクが有効である事"  do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end
    
    it "[有効]異なるタイトルなら有効である事" do
      FactoryBot.create(:task)
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end
    
    it "[無効]タスクにタイトルが無い事" do
      task = FactoryBot.build(:task,title: nil)
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end
    
    it "[無効]タスクにステータスが選択されていない事" do
      task = FactoryBot.build(:task,status: nil)
      expect(task).to be_invalid
      expect(task.errors[:status]).to include("can't be blank")
    end
    
    it "[無効]タイトルが既に存在する事" do
      task = FactoryBot.create(:task)
      othertask = FactoryBot.build(:task,title: task.title)
      expect(othertask).to be_invalid
      expect(othertask.errors[:title]).to include("has already been taken")
    end
  end
  
end
