(function(){
  'use strict';
  var multiChoiceMacro = function($scope, cardService, multiChoiceRandomizer) {
    var isCardExists = function() {
      return (typeof CARD == "object");
    };
    var buildNewCard = function() {
      $scope.card = {};
      $scope.card.macro = "multi_choice";
      $scope.card.dynamicCard = {
        type: 'multi_choice',
        data: {
          question: "",
          answers: [""],
          distractors: [""],
          answerComment: ""
        }
      };
    };
        
    if (isCardExists()) {
      $scope.card = cardService.parseCard(CARD);
    } else {
      buildNewCard();
    }
    var dynamicData = $scope.card.dynamicCard.data;
    $scope.dynamicCard = $scope.card.dynamicCard;
    
    
    $scope.addCorrect = function() {
      dynamicData.answers.push("");
    }
    $scope.removeCorrect = function() {
      dynamicData.answers.pop();
    }
    $scope.addDistractor = function() {
      dynamicData.distractors.push(""); 
    }
    $scope.removeDistractor = function() {
      dynamicData.distractors.pop();
    }
    
    var update = function() {
      $scope.card.ready = false;
      $scope.dynamicCardDataString = JSON.stringify($scope.card.dynamicCard);
      $scope.card.ready = true;
      multiChoiceRandomizer.generateChoices($scope.card);
    }

    $scope.isReveal = false;
    
    $scope.toggle = function() {
      $scope.card.backVisible = !$scope.card.backVisible;
    };
    
    $scope.$watch('card.dynamicCard.data',function(){
      update();
    },true);
  };
  app.controller('multiChoiceMacro',['$scope','cardService', 'multiChoiceRandomizer', multiChoiceMacro]);
})();