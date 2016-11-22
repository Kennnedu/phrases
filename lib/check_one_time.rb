class CheckOneTime
  def call(last_user_id, current_user_id)
    raise 'Error' if last_user_id == current_user_id
  end
end
