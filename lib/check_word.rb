class CheckWord
  def call(word)
    raise 'ArgumentError' if /(\.){1}/ =~ word || /(,|!|:|;|\?|-){2}/ =~ word
  end
end
