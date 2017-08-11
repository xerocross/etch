(function(){
  var foreignVocab = function($scope, $timeout, crypt, math,foreignVocabPresenter) {
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

    $scope.$watch('originWord',function(){
      $scope.scan();
    });
    $scope.$watch('targetWord',function(){
      $scope.scan();
    });
    $scope.$watch('language',function(){
      $scope.scan();
      
    });
  
    $scope.scan = function() {
      if (localStorage !== null) {
        localStorage.setItem('language',$scope.language);
      }
      
      var data = {
        originWord: $scope.originWord,
        targetWord: $scope.targetWord,
        language: $scope.language
      } 
      var cardObj = {
        type: 'foreign_vocab',
        data: data
      }
      
      $scope.cardData = JSON.stringify(cardObj);
      
      var cardPresentation = foreignVocabPresenter.present(data);
      console.log(data)
      $scope.front_side = cardPresentation.front_side;
      $scope.back_side = cardPresentation.back_side;

      if ($scope.toWord)
        $scope.back_side = $scope.toWord;
      $timeout();
    }
    if (typeof CARD_DATA == "string") {
      var cardObj = crypt.decrypt(CARD_DATA); 

      $scope.data = JSON.parse(cardObj).data;
      $scope.originWord = $scope.data.originWord;
      $scope.targetWord = $scope.data.targetWord;
      $scope.language = $scope.data.language;
    } else {
      
      if (localStorage !== null && localStorage.getItem('language')) {
        console.log("getting local storage");
        $scope.language = localStorage.getItem('language');

      }
      $scope.originWord = "";
      $scope.targetWord = "";
      if (typeof($scope.language) === "undefined")
        $scope.language = "";
    }
  };
  app.controller('foreignVocab',['$scope','$timeout','crypt','math','foreignVocabPresenter',foreignVocab]);
})();