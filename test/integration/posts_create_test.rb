require 'test_helper'

class PostsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "unable to create posts if not logged in" do
    get new_post_path
    assert_redirected_to root_url
  end

  test "able to create post when logged in" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password',
                                          user_id: @user.id } }
    get new_post_path
    assert_template 'posts/new'
    post posts_path, params: { post: { user_id: @user.id,
                                       title: "",
                                       content: "" } }
    assert_template 'posts/new'
    assert_select "div.errors", count: 3

    post posts_path, params: { post: { user_id: @user.id,
                                       title: "Test Title",
                                       content: "Test Content" } }
    assert_redirected_to posts_path
    follow_redirect!
    assert_template 'posts/index'
    assert_not flash.empty?
    assert_select "h4", text: "Test Title- Person 1"
    assert_select "p", text: "Test Content"
  end
end
