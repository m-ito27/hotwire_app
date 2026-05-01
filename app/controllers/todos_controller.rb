class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[update destroy]

  def index
    @todos = current_user.todos.order(created_at: :desc)
    @todo = current_user.todos.build
  end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to todos_path }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_todo_form",
            partial: "todos/form",
            locals: { todo: @todo }
          ), status: :unprocessable_entity
        end
        format.html do
          @todos = current_user.todos.order(created_at: :desc)
          render :index, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    @todo.update(todo_params)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_path }
    end
  end

  def destroy
    @todo.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_path }
    end
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :completed)
  end
end
