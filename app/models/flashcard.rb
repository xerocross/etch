class Flashcard < ApplicationRecord
  has_many :updates
  belongs_to :user
  has_and_belongs_to_many :keywords
  DUE = 1
  NOT_DUE = 0
  def self.where_user_is(user)
    self.where(:user_id=>user)
  end

  scope :due, -> {where('due_model > 0.5')}
  scope :still_learning, -> {where(still_learning: true)}
  
  def due
    where('due_hyp' > 0.5)
  end
  

  
  def self.where_due()
    cardsDue = []
    self.all.each do |card|
      cardsDue.push card if card.compute_due
    end
    cardsDue
  end

  def self.where_is_learning()
    cards_learning = []
    self.all.each do |card|
      cards_learning.push card if card.is_learning
    end
    cards_learning
  end

  def got_it
    add_review(user_response: 'got_it')
    self.still_learning = false
  end

  def too_soon
    add_review(user_response: 'too_soon')
    argument = get_learning_parameters
    expected_result = NOT_DUE
    user.brain.learn(argument, expected_result)
  end

  def too_late
    add_review(user_response: 'too_late')
    argument = get_learning_parameters
    expected_result = DUE
    user.brain.learn(argument, expected_result)
  end


  def add_review(hash)
    update = Update.new()

    puts hash[:created_at]
    update.user_response = hash[:user_response]
    update.flashcard_id = id
    update.save!
    if !hash[:created_at].nil?
      update.created_at = hash[:created_at]
      update.save!
    end
  end

  def self.learning_params(reps, gap)
    reps_normalized = reps/5.0
    gap_normalized = gap/40.0
    gap_cube =  (gap/40.0)**10
    [1, reps_normalized, reps_normalized**2, gap_normalized, gap_cube]
  end

  def get_learning_parameters
    reps = num_reps
    gap_x = gap
    Flashcard.learning_params(num_reps, gap_x)
  end


  def compute_due
    update_still_learning
    update_due_model
      
    if !still_learning
      due_model > 0.5 ? true : false
    else
      false
    end
  end
  
  def update_due_model
    self.still_learning = (num_reps == 0)
    x = get_learning_parameters
    self.due_model = user.brain.hypothesis(x)
  end

  
  def update_still_learning
    self.still_learning = (num_reps == 0)
  end

  def num_reps
    updates_array = updates
    updates_array.length
  end

  def gap
    last_review = updates.order(created_at: :desc).first
    if !last_review.nil?
      last_review_time = last_review.created_at
      now = Time.now
      diff = now-last_review_time
      gap = (now-last_review_time)/60/60/24
      gap.floor
    else
      gap = 0
    end
  end
end
