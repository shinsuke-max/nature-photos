require 'rails_helper'

RSpec.describe "Sign-ups", type: :system do
  it "user successfully signs up" do
    visit root_path
    click_link "ログイン"
    click_link "新規登録する"

    expect {
      fill_in "名前", with: "Fujiwara"
      fill_in "メールアドレス", with: "test@sample.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認）", with: "password"
      click_button "登録する"
    }.to change(User, :count).by(1)

    expect(page).to have_content "アカウント登録しました。"
    expect(current_path).to eq root_path
    expect(page).to have_link "投稿"
    expect(page).to have_link "投稿一覧"
    expect(page).to have_link "アカウント"
  end
end
