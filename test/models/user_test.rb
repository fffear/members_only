require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name:                  "Michael Jordan",
                     email:                 "michael@jordan.com",
                     password:              "foobar",
                     password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  # Presence validation tests
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password =              "   "
    @user.password_confirmation = "   "
    assert_not @user.valid?
  end

  # Length validation tests
  test "name should not be over 50 characters" do
    @user.name = "a" * 50
    assert @user.valid?
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be over 255 characters" do
    @user.email = "a" * 243 + "@example.com"
    assert @user.valid?
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
    @user.email = "a" * 245 + "@example.com"
    assert_not @user.valid?
  end

  test "password should be at least 6 characters" do
    @user.password = "a" * 5
    @user.password_confirmation = @user.password
    assert_not @user.valid?
    @user.password = "a" * 6
    @user.password_confirmation = @user.password
    assert @user.valid?
    @user.password = "a" * 7
    @user.password_confirmation = @user.password
    assert @user.valid?
  end

  # Uniqueness validations
  test "email addresses should be unique" do
    user = @user.dup
    user.email = user.email.upcase
    user.save
    assert_not @user.valid?
  end

  test "email addresses should be saved in lower case" do
    mixed_case_email = @user.email = "TeSt@ExamPLE.Com"
    @user.save
    assert_equal mixed_case_email.downcase, @user.email
  end

  # Format validations
  test "email validation should reject invalid addresses" do
    invalid_email_addresses = %w{user@example,com user_at_foo.org user.name@example.
                                 foo@bar_baz.com foo@bar+baz.com foo@bar..com}
    invalid_email_addresses.each do |invalid_email_address|
      @user.email = invalid_email_address
      assert_not @user.valid?, "#{invalid_email_address} should not be valid"
    end
  end

  test "email validation should accept valid addresses" do
    valid_email_addresses = %w{user@example.com USER@foo.COM A_US-ER@foo.bar.org
                               first.last@foo.jp alice+bob@baz.cn}
    valid_email_addresses.each do |valid_email_address|
      @user.email = valid_email_address
      assert @user.valid?, "#{valid_email_address} should be valid"
    end
  end

  # Authenticate password
  test "authenticate method returns false if password is incorrect" do
    assert_not @user.authenticate("foo")
  end

  test "authenticate method returns true if password is correct" do
    assert @user.authenticate("foobar")
  end
end
