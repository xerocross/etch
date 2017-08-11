var importService = function() {
  
  var import_multi_choice_card_version01 = function(pickledCard) {
    var card = {};
    card.data = {};
    var dynamicCard = card.data;
    dynamicCard.type = "multi_choice";
    dynamicCard.data = {};
    dynamicCard.data.question = pickledCard.question;
    try {
    dynamicCard.data.distractors = pickledCard.distractors;
    dynamicCard.data.answers = pickledCard.correct_choices;
    }
    catch(e) {
      console.log(e);
      throw "err"
    }
    dynamicCard.data.answerComment = pickledCard.answer_comment;
    return card;  
  }
  var import_fill_blank_version01 = function(pickledCard) {
    console.log("importing fill_Blank");
    console.log(pickledCard);
    var card = {};
    card.data = {};
    var dynamicCard = card.data;
    dynamicCard.type = "fill_blank";
    dynamicCard.data = {};
    dynamicCard.data.generator = pickledCard.generator;
    console.log(card);
    return card;
  }
  var import_default_version01 = function(pickledCard) {
    var card = {};
    card.front_side = pickledCard.front;
    card.back_side = pickledCard.back_side;
    return card;
  }
  
  var import_version01 = function (pickledCard) {
    var returnObj;
    
    switch(pickledCard.type) {
      case "multi_choice":
        returnObj = import_multi_choice_card_version01(pickledCard);
        break;
      case "fill_blank":
        returnObj = import_fill_blank_version01(pickledCard);
        break;
      default:
      
    }
    returnObj.keywords = pickledCard.keywords;
    returnObj.macro = pickledCard.type;
    return returnObj;
  };
  
  
  
  
  this.import = function (pickledCard) {
    return import_version01(pickledCard);
  };
};
app.service('importService',[importService]);