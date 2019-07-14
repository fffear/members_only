class PostsController < ApplicationController
  before_action :check_login_status, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Post has been created."
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def index
    @posts = Post.all
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :user_id)
    end
end
