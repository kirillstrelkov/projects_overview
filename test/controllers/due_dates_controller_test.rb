require 'test_helper'

class DueDatesControllerTest < ActionController::TestCase
  setup do
    @due_date = due_dates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:due_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create due_date" do
    assert_difference('DueDate.count') do
      post :create, due_date: { date: @due_date.date, description: @due_date.description, name: @due_date.name, progress: @due_date.progress, project_id: @due_date.project_id }
    end

    assert_redirected_to due_date_path(assigns(:due_date))
  end

  test "should show due_date" do
    get :show, id: @due_date
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @due_date
    assert_response :success
  end

  test "should update due_date" do
    patch :update, id: @due_date, due_date: { date: @due_date.date, description: @due_date.description, name: @due_date.name, progress: @due_date.progress, project_id: @due_date.project_id }
    assert_redirected_to due_date_path(assigns(:due_date))
  end

  test "should destroy due_date" do
    assert_difference('DueDate.count', -1) do
      delete :destroy, id: @due_date
    end

    assert_redirected_to due_dates_path
  end
end
