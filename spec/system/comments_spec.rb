require 'rails_helper'

RSpec.describe "Comments", type: :system do

  it "user creates a new comment" do
    user = create(:user)
    post = create(:post)

    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect {
      visit post_path(post)
      fill_in 'comment[comment]', with: "Test Comment"
      click_button "コメントする"

      expect(page).to have_content "コメントしました"
      expect(page).to have_content "Test Comment"
    }.to change(user.comments, :count).by(1)
  end

  it "user edit a comment" do
    user = create(:user)
    post = create(:post)
    comment = Comment.create(comment: "Test", user_id: user.id, post_id: post.id)

    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect {
      visit post_path(post)
      visit edit_post_comment_path(post.id, comment)
      fill_in "コメント", with: "Hoge"
      click_button "編集"

      expect(page).to have_content "コメントが更新されました"
      expect(current_path).to eq root_path
    }.to_not change(user.comments, :count)
  end

  it "user delete a comment" do
    user = create(:user)
    post = create(:post)
    comment = Comment.create(comment: "Test", user_id: user.id, post_id: post.id)

    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"

    expect {
      visit post_path(post)
      visit edit_post_comment_path(post.id, comment)

      page.accept_confirm do
        click_on "削除"
      end

      expect(page).to have_content "コメントが削除されました"
      expect(current_path).to eq root_path
    }.to change(user.comments, :count).by(-1)
  end
end
