(function() {
  "use strict";
  var flashcardsManager = function($scope, cardService, server, exportService) {
    $scope.attachedKeywords = [];
    $scope.cards = [];
    
    $scope.getSelected = function() {
      var selected = [];
      for (var i = 0; i < $scope.cards.length; i++) {
        if ($scope.cards[i].selected)
          selected.push($scope.cards[i].id);
      }
      return selected;
    };
    $scope.getSelectedIndices = function() {
      var selectedIndices = [];
      for (var i = 0; i < $scope.cards.length; i++) {
        if ($scope.cards[i].selected)
          selected.push(i);
      }
      return selectedIndices;
    };
    

    var getExportQuery = function(isExportSelected) {
      var query = {
          keywords: JSON.stringify($scope.attachedkeywordIds)
        }
      if (isExportSelected)
        query.cardIds = JSON.stringify($scope.getSelected())
      return query;
    };

    $scope.export = function(isExportSelected) {
      var urlString = "/flashcards_manager/export?";
      var exportQuery = getExportQuery(isExportSelected);
      for (var param in exportQuery) {
        if (exportQuery.hasOwnProperty(param)) {
          if (typeof(param) === 'string' && param.length > 0 && param !== '0') {
            urlString += param + "=" + exportQuery[param] + "&";
            
          }
        }
      }
      window.location = urlString;
    };
    
    $scope.more = function() {
      console.log($scope.cards);
      $scope.page += 1;
      if (typeof($scope.attachedkeywordIds) == 'object' && $scope.attachedkeywordIds.length > 0) {
      var query = {
          keywords: JSON.stringify($scope.attachedkeywordIds),
          page: $scope.page
        }
      } else {
        query = {
          page: $scope.page
        };
      }
      server.getCards("/flashcards.json", query, $scope.cards)
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
    
    $scope.$watchCollection('attachedkeywordIds',function(){
      $scope.cards = [];
      $scope.page = 0;
      $scope.more();
    });
    
    $scope.show = function(cardId) {
      var location = "/flashcards/" + cardId;
      window.location = location;
    };
    
  };
  app.controller('flashcardsManager',['$scope','cardService','server', 'exportService', flashcardsManager]);
  
})();