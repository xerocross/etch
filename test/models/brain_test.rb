require 'test_helper'
class UserTest < ActiveSupport::TestCase
  
  test "a new brain should have specified learning constants" do
    initial_learning_constants = [
      -0.11850, 
      0.24085,
      -1.18921,
      1.0149,1
      ]
    b = Brain.new()
    b.user = users(:adam)
    b.save!
    testConstants = JSON.parse(b.learning_constants)
    testConstants.length.times do |i|
      assert testConstants[i] == initial_learning_constants[i]
    end
  end
  
  test "a new brain should have due gaps as specified" do
    expected_due_gaps = [5, 5, 9, 16, 27, 35]
    b = Brain.new()
    b.user = users(:adam)
    b.save!
    predicted_due_gaps = b.prognosticate
    expected_due_gaps.length.times do |i|
      assert predicted_due_gaps[i] == expected_due_gaps[i]
    end
  end
  
  test "learning with expected 0 should decrease hypothesis" do
    user = users(:adam)
    args = [1,5,25,5,25]
    hyp_before = user.brain.hypothesis(args)
    user.brain.learn([1,5,25,5,25],0)
    hyp_after = user.brain.hypothesis(args)
    assert hyp_after < hyp_before
    puts "expecting #{hyp_after} < #{hyp_before}"
  end

  test "learning with expected 1 should increase hypothesis" do
    user = users(:adam)
    args = [1,5,25,5,25]
    hyp_before = user.brain.hypothesis(args)
    user.brain.learn([1,5,25,5,25],1)
    hyp_after = user.brain.hypothesis(args)
    assert hyp_after > hyp_before
    puts "expecting #{hyp_after} > #{hyp_before}"
  end
  
end
