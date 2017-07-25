class Brain < ApplicationRecord
  belongs_to :user
  @@ALPHA = 0.05
  @@INITIAL_LEARNING_CONSTANTS = [-0.11850, 0.24085, -1.18921, 1.0149, 1]
  after_create :init_learning_constants
  
  def hypothesis(x)
    u = JSON.parse(self.learning_constants)
    matrix_product = 0
    u.length.times do |i|
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
    learning_constants_array = JSON.parse(self.learning_constants)
    # The following loop computation is the
    # heart of the gradient descent algorithm as
    # applied here.  We must not attempt to mutate
    # self.learning_constants directly inside this
    # loop.  It will be updated after we have
    # computed all of the updates here.
    learning_constants_array.length.times do |i|
      learning_constants_array[i] = learning_constants_array[i] - @@ALPHA*(hypothesis(arguments) - expected_value)*arguments[i]
    end
    # Now we perform the update.
    self.learning_constants = learning_constants_array.to_json
  end
  
  private
  
  def init_learning_constants
    self.learning_constants = @@INITIAL_LEARNING_CONSTANTS.to_s
    #self.save!
  end
end
