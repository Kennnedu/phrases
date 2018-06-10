class Word < ActiveRecord::Base
  belongs_to :user
  belongs_to :phrase

  validates :word, :previous_phrase, presence: true

  validate :correct_word?, :same_user_previous_word?

  before_validation :set_previous_phrase
  after_create :change_state_of_phrase

  private

  def correct_word?
    if /(\.){1}/ =~ word || /(,|!|:|;|\?|-){2}/ =~ word || /[\s]/ =~ word || word.empty?
      errors.add(:word, 'Incorrect word!')
    end
  end

  def same_user_previous_word?
    user_id_previous_word = Phrase.find(phrase_id).words.last.try(:user_id)
    if user_id_previous_word == user_id
      errors.add(:user_id, 'You last added a word!')
    end
  end

  def set_previous_phrase
    self.previous_phrase = phrase.current_state
  end

  def change_state_of_phrase
    phrase.update_attribute(:current_state, "#{previous_phrase} #{word}")
  end
end