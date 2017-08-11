(function() {
  var flashcardsShow = function($scope, cardService) {
    var card = CARD;
    //global CARD is rendered into the view directly from server
    $scope.card = cardService.parseCard(card);
  }
  app.controller('flashcardsShow',['$scope','cardService',flashcardsShow]);
  
  
  var flashcardsIndex = function($scope, cardService, server) {
    $scope.attachedKeywords = [];
    
    $scope.more = function() {
      $scope.page += 1;
      cardService.getCards({page: $scope.page}, $scope.cards);
    };
    var getCardById = function(id) {
      for (var i = 0; i < $scope.cards.length; i++)
        if ($scope.cards[i].id == id)
          return $scope.cards[i]
      return null;
    };
    
    var removeCardByIndex = function(index) {
      $scope.cards.splice(index,1);  
    };
    
    $scope.delete = function(event, id, index) {
      event.preventDefault();
      var card = getCardById(id);
      var callback = function() {
        removeCardByIndex(index);
      };
      if (confirm("Delete card " + card.id + "?")) {
        server.delete(card.id, callback);
      }
    };
    $scope.cards = [];
    $scope.page = 1;
    cardService.getCards({page: $scope.page}, $scope.cards);
    
    $scope.$watchCollection('attachedKeywords',function(){
      console.log("^^^^inside flashcardIndex");
      console.log($scope.attachedKeywords);
    });
    
    $scope.$watchCollection('attachedkeywordIds',function(){
    });
    
    
  };
  app.controller('flashcardsIndex',['$scope','cardService','server', flashcardsIndex]);
  
})();