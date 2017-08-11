(function(){
  var cardForm = function($scope, $timeout, crypt, math){
    $scope.front_side = crypt.decrypt(FRONT);
    $scope.back_side = crypt.decrypt(BACK);
  }
  app.controller('cardForm',['$scope','$timeout','crypt','math',cardForm]);
})();