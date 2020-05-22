require 'rails_helper'

RSpec.describe "Posts", type: :system do
  before do
    @user = create(:user)
    @post = create(:post, user_id: @user.id, content: "testtest")

    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード", with: @user.password
    click_button "ログインする"
  end

  it "user creates a new post" do
    expect do
      click_link "投稿"
      fill_in "キャプション", with: "Test Post"
      attach_file "画像", "#{Rails.root}/spec/fixtures/sample.jpg"
      click_button "投稿"

      expect(page).to have_content "投稿が保存されました"
      expect(page).to have_content "Test Post"
    end.to change(@user.posts, :count).by(1)
  end

  it "user edit a post" do
    expect do
      visit post_path(@post)
      click_link "編集"
      fill_in "キャプション", with: "Edit Test"
      attach_file "画像", "#{Rails.root}/spec/fixtures/sample.jpg"
      click_button "編集"

      expect(current_path).to eq post_path(@post)
      expect(page).to have_content "投稿が更新されました"
      expect(page).to have_content "Edit Test"
    end.not_to change(@user.posts, :count)
  end

  # it "user delete a post" do
  #  expect {
  #    visit post_path(@post)
  #    page.accept_confirm do
  #      click_on "削除"
  #    end
  #
  #    expect(current_path).to eq root_path
  #    expect(page).to have_content "投稿が削除されました"
  #  }.to change(@user.posts, :count).by(-1)
  # end
end
