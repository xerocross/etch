json.extract! flashcard, :id, :front_side, :back_side, :created_at, :data, :macro, :due_model, :still_learning
json.keywords flashcard.keywords
json.updates flashcard.updates.select(:id,:user_response,:created_at)
json.url flashcard_url(flashcard, format: :json)
json.auth form_authenticity_token
