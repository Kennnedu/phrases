# when user update phrases
# Example call CheckWord.new.call(params[:phrase][:name])
class CheckWord
  def call(word)
    raise 'ArgumentError' if /(\.){1}/ =~ word || /(,|!|:|;|\?|-){2}/ =~ word || /[\s]/ =~ word || word.empty?
  end
end
