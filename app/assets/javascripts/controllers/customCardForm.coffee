customCardForm = ($scope, crypt)->
  $scope.front_side = crypt.decrypt(CARD.front_side);
  $scope.back_side = crypt.decrypt(CARD.back_side);
app.controller('customCardForm',['$scope','crypt',customCardForm]);