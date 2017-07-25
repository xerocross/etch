class Keyword < ApplicationRecord
  validates :text, presence: true
  has_and_belongs_to_many :flashcards
  belongs_to :user

  def self.id_array(keyword_array)
    id_array = []
    keyword_array.each{|k| id_array.push(k.id)}
    id_array
  end
  
  
  
  def self.string_to_array (user, array_string)
    stringArray = JSON.parse(array_string)
    keywords = []
    stringArray.each do |keytext|
      keyword = user.keywords.find_by_text keytext
      keywords << keyword if not keyword.nil?
    end
    keywords
  end

end
