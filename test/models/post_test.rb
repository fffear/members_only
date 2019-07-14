require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @post = Post.new(title: "Test Title",
                     content: "Test Content",
                     user_id: 1)
  end
  
  test "title can't be empty" do
    @post.title = "   "
    assert_not @post.valid?
  end

  test "content can't be empty" do
    @post.content = "   "
    assert_not @post.valid?
  end

  test "title has to be 50 characters or less" do
    @post.title = "a" * 50
    assert @post.valid?
    @post.title = "a" * 51
    assert_not @post.valid?
  end

  test "content has to have 2 characters or more" do
    @post.content = "a" * 2
    assert @post.valid?
    @post.content = "a" * 1
    assert_not @post.valid?
  end
end
