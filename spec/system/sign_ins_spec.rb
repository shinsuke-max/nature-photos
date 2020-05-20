require 'rails_helper'

RSpec.describe "Sign in", type: :system do
  let(:user) { create(:user) }

  it "user signs in" do
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"
    expect(page).to have_content "ログインしました。"
  end

  it "user logout" do
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    click_link "アカウント"
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました。"
  end
end
