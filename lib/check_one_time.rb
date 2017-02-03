# when user update phrases
# Example call CheckOneTime.new.call(@phrase.histories.last.user.id, @user.id)
class CheckOneTime
  def call(last_user_id, current_user_id)
    raise 'Error' if last_user_id == current_user_id
  end
end
