require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    post signup_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "baz" } }
    assert_template 'users/new'
    assert_select "p.errors", 4
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "Test Person",
                                          email: "user@valid.com",
                                          password: "foobar",
                                          password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
