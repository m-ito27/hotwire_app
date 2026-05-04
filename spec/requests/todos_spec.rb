require "rails_helper"

RSpec.describe "Todos", type: :request do
  let(:user) { create(:user) }

  describe "GET /todos" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        get todos_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before do
        sign_in user
        create(:todo, user: user, title: "自分のTODO")
        create(:todo, title: "他人のTODO")
      end

      it "200を返し、自分のTODOのみ表示する" do
        get todos_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("自分のTODO")
        expect(response.body).not_to include("他人のTODO")
      end
    end
  end

  describe "POST /todos" do
    before { sign_in user }

    context "有効なパラメータの場合" do
      it "TODOを作成し、HTMLリクエストではindexにリダイレクトする" do
        expect {
          post todos_path, params: { todo: { title: "新しいTODO" } }
        }.to change(user.todos, :count).by(1)

        expect(response).to redirect_to(todos_path)
      end

      it "Turbo Streamリクエストではturbo_streamを返す" do
        post todos_path,
             params: { todo: { title: "Turboで追加" } },
             headers: { "Accept" => "text/vnd.turbo-stream.html" }

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "titleが空の場合" do
      it "TODOを作成せず、unprocessable_entityを返す" do
        expect {
          post todos_path, params: { todo: { title: "" } }
        }.not_to change(Todo, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /todos/:id" do
    before { sign_in user }
    let!(:todo) { create(:todo, user: user, completed: false) }

    it "completedの値を更新する" do
      patch todo_path(todo), params: { todo: { completed: true } }

      expect(todo.reload.completed).to be true
      expect(response).to redirect_to(todos_path)
    end

    it "他人のTODOは更新できず404となる" do
      other_todo = create(:todo)

      patch todo_path(other_todo), params: { todo: { completed: true } }

      expect(response).to have_http_status(:not_found)
      expect(other_todo.reload.completed).to be false
    end
  end

  describe "DELETE /todos/:id" do
    before { sign_in user }
    let!(:todo) { create(:todo, user: user) }

    it "TODOを削除する" do
      expect {
        delete todo_path(todo)
      }.to change(user.todos, :count).by(-1)

      expect(response).to redirect_to(todos_path)
    end
  end
end
