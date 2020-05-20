require 'rails_helper'

RSpec.describe "likes", type: :system do
  it "user creates a new like" do
    user = create(:user)
    post = create(:post)

    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect {
      visit post_path(post)
      click_link "いいね！する"

      expect(page).to have_content "いいね！しました"
      expect(page).to have_content "1 いいね！"
    }.to change(user.likes, :count).by(1)
  end

  it "user delete a like" do
    user = create(:user)
    post = create(:post)

    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect {
      visit post_path(post)
      click_link "いいね！する"

      expect(page).to have_content "いいね！しました"
      expect(page).to have_content "1 いいね！"

      click_link "いいね！を取り消す"

      expect(page).to have_content "いいねが取り消されました"
      expect(page).to have_content "0 いいね！"

    }.to_not change(user.likes, :count)
  end
end
