require "test_helper"

class ProjectEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_entry = project_entries(:one)
  end

  test "should get index" do
    get project_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_project_entry_url
    assert_response :success
  end

  test "should create project_entry" do
    assert_difference("ProjectEntry.count") do
      post project_entries_url, params: { project_entry: { assigned_fullname: @project_entry.assigned_fullname, assigned_id: @project_entry.assigned_id, creator_fullname: @project_entry.creator_fullname, creator_id: @project_entry.creator_id, description: @project_entry.description, id: @project_entry.id, priority: @project_entry.priority, project_id: @project_entry.project_id, status: @project_entry.status, title: @project_entry.title } }
    end

    assert_redirected_to project_entry_url(ProjectEntry.last)
  end

  test "should show project_entry" do
    get project_entry_url(@project_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_entry_url(@project_entry)
    assert_response :success
  end

  test "should update project_entry" do
    patch project_entry_url(@project_entry), params: { project_entry: { assigned_fullname: @project_entry.assigned_fullname, assigned_id: @project_entry.assigned_id, creator_fullname: @project_entry.creator_fullname, creator_id: @project_entry.creator_id, description: @project_entry.description, id: @project_entry.id, priority: @project_entry.priority, project_id: @project_entry.project_id, status: @project_entry.status, title: @project_entry.title } }
    assert_redirected_to project_entry_url(@project_entry)
  end

  test "should destroy project_entry" do
    assert_difference("ProjectEntry.count", -1) do
      delete project_entry_url(@project_entry)
    end

    assert_redirected_to project_entries_url
  end
end
