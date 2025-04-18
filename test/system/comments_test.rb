require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @comment = comments(:one)
  end

  test "visiting the index" do
    visit comments_url
    assert_selector "h1", text: "Comments"
  end

  test "should create comment" do
    visit comments_url
    click_on "New comment"

    fill_in "Action", with: @comment.action_id
    fill_in "Author fullname", with: @comment.author_fullname
    fill_in "Author", with: @comment.author_id
    fill_in "Body", with: @comment.body
    fill_in "Entry", with: @comment.entry_id
    fill_in "Id", with: @comment.id
    fill_in "Project", with: @comment.project_id
    fill_in "Title", with: @comment.title
    click_on "Create Comment"

    assert_text "Comment was successfully created"
    click_on "Back"
  end

  test "should update Comment" do
    visit comment_url(@comment)
    click_on "Edit this comment", match: :first

    fill_in "Action", with: @comment.action_id
    fill_in "Author fullname", with: @comment.author_fullname
    fill_in "Author", with: @comment.author_id
    fill_in "Body", with: @comment.body
    fill_in "Entry", with: @comment.entry_id
    fill_in "Id", with: @comment.id
    fill_in "Project", with: @comment.project_id
    fill_in "Title", with: @comment.title
    click_on "Update Comment"

    assert_text "Comment was successfully updated"
    click_on "Back"
  end

  test "should destroy Comment" do
    visit comment_url(@comment)
    click_on "Destroy this comment", match: :first

    assert_text "Comment was successfully destroyed"
  end
end
