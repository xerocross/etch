cardModel  = ->
  translations =
    "multi_choice" :
      "correct_choices" : "answers"
      "answer_comment": "answerComment"
    "foreign_vocab" :
      "target_word" : "targetWord"
      "origin_word" : "originWord"
  
  cardSchemas = 
    "multi_choice" : {
      "question" : "string"
      "correct_choices" : "string[]"
      "distractors" : "string[]"
      "answer_comment" : "string"
    },
    "fill_blank" : {
      "generator": "string"
    },
    "foreign_vocab" : {
      "target_word" : "string"
      "origin_word" : "string"
      "language" : "string"
    },
    "custom" : {
      "front_side" : "string"
      "back_side" : "string"
    }
  
  @translate = (card)->
    schema = cardSchemas[card.macro]
    translatedCard = {type: card.macro}
    if card.macro is "custom"
      console.log "A"
      for key,value of schema
        translatedCard[key] = card[key]
    else
      console.log "B"
      dynamicCard = JSON.parse(card.data);
      for key,value of schema
        if (dynamicCard.data[key]?)
          translatedCard[key] = dynamicCard.data[key]
        else 
          if translations.hasOwnProperty(card.macro) and translations[card.macro].hasOwnProperty(key)
            translationKey = translations[card.macro][key]
            if (translationKey?)
              console.log "F"
              translatedCard[key] = dynamicCard.data[translationKey]
    translatedCard
      
  
  @getSchema = (name)->
    cardSchemas[name]
  
  this

window.app.service('cardModel',[cardModel]);