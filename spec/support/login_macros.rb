module LoginMacros
  # simple ruby module that accepts user obj and assigns it to session
  def set_user_session(user)
    session[:user_id] = user.id
  end
end