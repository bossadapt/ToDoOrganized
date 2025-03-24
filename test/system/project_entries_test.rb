require "application_system_test_case"

class ProjectEntriesTest < ApplicationSystemTestCase
  setup do
    @project_entry = project_entries(:one)
  end

  test "visiting the index" do
    visit project_entries_url
    assert_selector "h1", text: "Project entries"
  end

  test "should create project entry" do
    visit project_entries_url
    click_on "New project entry"

    fill_in "Assigned fullname", with: @project_entry.assigned_fullname
    fill_in "Assigned", with: @project_entry.assigned_id
    fill_in "Creator fullname", with: @project_entry.creator_fullname
    fill_in "Creator", with: @project_entry.creator_id
    fill_in "Description", with: @project_entry.description
    fill_in "Id", with: @project_entry.id
    fill_in "Priority", with: @project_entry.priority
    fill_in "Project", with: @project_entry.project_id
    fill_in "Status", with: @project_entry.status
    fill_in "Title", with: @project_entry.title
    click_on "Create Project entry"

    assert_text "Project entry was successfully created"
    click_on "Back"
  end

  test "should update Project entry" do
    visit project_entry_url(@project_entry)
    click_on "Edit this project entry", match: :first

    fill_in "Assigned fullname", with: @project_entry.assigned_fullname
    fill_in "Assigned", with: @project_entry.assigned_id
    fill_in "Creator fullname", with: @project_entry.creator_fullname
    fill_in "Creator", with: @project_entry.creator_id
    fill_in "Description", with: @project_entry.description
    fill_in "Id", with: @project_entry.id
    fill_in "Priority", with: @project_entry.priority
    fill_in "Project", with: @project_entry.project_id
    fill_in "Status", with: @project_entry.status
    fill_in "Title", with: @project_entry.title
    click_on "Update Project entry"

    assert_text "Project entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Project entry" do
    visit project_entry_url(@project_entry)
    click_on "Destroy this project entry", match: :first

    assert_text "Project entry was successfully destroyed"
  end
end
