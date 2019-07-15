module SessionsHelper
  # Logs in given user
  def log_in user
    session[:user_id] = user.id
  end

  # Remember user
  def remember(user)
    user.change_remember_token_and_digest
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.signed[:user_id] = user.id
  end

  def forget(user)
    cookies.delete(:remember_token)
    cookies.delete(:user_id)
  end

  # Returns the current logged in use (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      @current_user = User.find_by(id: cookies.signed[:user_id])
      if @current_user && @current_user.authenticated?(cookies[:remember_token])
        log_in @current_user
        @current_user
      end
    end
  end

  # Returns true if there is a user logged in, false if not
  def logged_in?
    !current_user.nil?
  end

  # Logs out current user
  def log_out
    session.delete(:user_id)
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    @current_user = nil
  end

  def check_login_status
    unless logged_in?
      flash[:danger] = "You are not logged in. Please log in."
      redirect_to root_url
      return
    end    
  end
end
