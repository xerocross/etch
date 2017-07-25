class Brain < ApplicationRecord
  belongs_to :user
  @@ALPHA = 0.05
  after_create :init_learning_constants
  
  def hypothesis(x)
    u = JSON.parse(learning_constants)
    matrix_product = 0
    5.times do |i|
      matrix_product += u[i]*x[i]
    end
    1/(1+Math.exp(-matrix_product))
  end
  
  def get_gap(num_reps)
    hyp = 0
    gap = -1
    
    while hyp < 0.5 do
      gap+= 1
      x = Flashcard.learning_params(num_reps,gap)
      hyp = hypothesis(x)
    end
    gap
  end
  
  def prognosticate
    gaps = []
    50.times do |i|
      gaps.push get_gap(i)
    end
    gaps
  end
  
  def learn(arguments, expected_value)
    new_constants = []
    learning_constants_array = JSON.parse(learning_constants)
    5.times do |i|
      new_constants[i] = learning_constants_array[i]
    end
    5.times do |i|
      new_constants[i] = learning_constants_array[i] - @@ALPHA*(hypothesis(arguments) - expected_value)*arguments[i]
    end
    5.times do |i|
      learning_constants_array[i] = new_constants[i]
    end
    write_attribute(:learning_constants, learning_constants_array.to_json)
    save
  end
  
  private
  
  def init_learning_constants
    self.learning_constants = "[-0.11850,0.24085,-1.18921,1.0149,1]";
    self.save!
    #self.learning_constants = '[0.99726894142137,-1.0206552928931498, -1.16727646446575, 0.9493447071068499]'
  end
end
