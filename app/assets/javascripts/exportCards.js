(function(){

  var exportCards = function($scope,$http,crypt,cardPickler, cardService, exportService, server) {
    $scope.exportText;

    var fetch = function() {
      
      var query = {
        "no_paginate": true,
        "cardIds": JSON.stringify(CARDS_LIST) 
      }
      $scope.cards = [];
      server.getCards("/flashcards.json", query, $scope.cards).then(function() {
        $scope.exportText  = exportService.getExportText($scope.cards);
        $scope.loading = false;
      });
    }
    $scope.loading = true;
    fetch();
  };

  app.controller('exportCards',['$scope','$http','crypt','cardPickler','cardService','exportService','server', exportCards]);

})();