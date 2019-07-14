require 'test_helper'

class PostsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @post = posts(:one)
  end

  test "index page without login" do
    get posts_path
    assert_select "h4", text: "Test Title 1"
    assert_select "p", text: "Test Content 1"
  end

  test "index page with login" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password',
                                          user_id: @user.id } }
    get posts_path
    assert_select "h4", text: "Test Title 1- #{User.find(@post.user_id).name}"
    assert_select "p", text: "Test Content 1"
  end
end
