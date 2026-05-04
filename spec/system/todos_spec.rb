require "rails_helper"

RSpec.describe "Todos", type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  it "TODOを追加できる" do
    visit todos_path

    fill_in "todo[title]", with: "牛乳を買う"
    click_on "追加"

    expect(page).to have_css("#todos li", text: "牛乳を買う")
    expect(user.todos.pluck(:title)).to include("牛乳を買う")
  end

  it "空のtitleではエラーが表示される" do
    visit todos_path

    fill_in "todo[title]", with: ""
    click_on "追加"

    expect(page).to have_css("ul.errors")
    expect(user.todos.reload).to be_empty
  end

  it "TODOを削除できる" do
    create(:todo, user: user, title: "削除対象")

    visit todos_path
    expect(page).to have_content("削除対象")

    click_on "削除"

    expect(page).not_to have_content("削除対象")
    expect(user.todos.reload).to be_empty
  end

  it "他のユーザーのTODOは表示されない" do
    create(:todo, user: user, title: "自分のやること")
    create(:todo, title: "他人のやること")

    visit todos_path

    expect(page).to have_content("自分のやること")
    expect(page).not_to have_content("他人のやること")
  end
end
