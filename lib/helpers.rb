module Helpers
  def authorize
    redirect '/sign_in' if session[:username].nil?
  end

  def not_authorize
    redirect '/' if session[:username]
  end

  def create_phrase(new_phrase, username)
    phrase = Phrase.create!(name: new_phrase)
    phrase.histories.create!(user_id: User.find_by(username: username).id, part_phrase: phrase.name)
    { method: 'create', id: phrase.id, phrase: phrase.name }.to_json
  rescue
    { status: 404, message: 'Error!' }.to_json
  end

  def update_phrase(phrase_params, username)
    user = User.find_by(username: username)
    phrase = Phrase.find(phrase_params['id'])
    check_word(phrase_params['phrase'])
    check_one_time(phrase.histories.last.user.id, user.id)
    phrase.update!(name: "#{phrase.name} #{phrase_params['phrase']}")
    phrase.histories.create!(user_id: user.id, part_phrase: phrase.name)
    { method: 'update', id: phrase.id, phrase: phrase.name, status: 200 }.to_json
  rescue
    { message: 'The word wasn\'t added!', status: 404 }.to_json
  end

private

  def check_word(word)
    raise 'ArgumentError' if /(\.){1}/ =~ word || /(,|!|:|;|\?|-){2}/ =~ word || /[\s]/ =~ word || word.empty?
  end

  def check_one_time(last_user_id, current_user_id)
    raise 'Error' if last_user_id == current_user_id
  end
end
