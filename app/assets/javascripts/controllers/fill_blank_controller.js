(function(){
  //CARD.data is a global defined in the view
  var fillInTheBlank = function($scope, $timeout, crypt, math,fillBlankPresenter) {
    $scope.card = {
      macro:'fill_blank',
      data:{},
      front_side:'something here',
      back_side:''
    };
    $scope.front_side = "";
    $scope.back_side = "";

    $scope.scanFront = function() {
      math.scan($scope.front_side)
    };
    $scope.scanBack = function() {
      math.scan($scope.back_side)
    };
    $scope.scanFront();
    $scope.scanBack();  
    
    var updateData = function(){
      
      var data = {
          generator: $scope.generator
        };
      $scope.cardData = JSON.stringify({
        type: 'fill_blank',
        data: data
      });
    }
    $scope.$watch('generator',function(){
      var card = fillBlankPresenter.present({generator: $scope.generator});
      $scope.card = card;

      $scope.card.macro = "fill_blank"
      
      $scope.card.data = $scope.cardData;
      
      $scope.card.ready = true;
      $scope.front_side =card.front_side;
      $scope.back_side =card.back_preview;
      updateData();
    });
    
    if (typeof CARD.data == "string") {
      var cardObj = crypt.decrypt(CARD.data); 

      $scope.data = JSON.parse(cardObj).data;
      $scope.generator = $scope.data.generator;
      
    }
    

  };
  app.controller('fillInTheBlank',['$scope','$timeout','crypt','math','fillBlankPresenter',fillInTheBlank]);

})();
