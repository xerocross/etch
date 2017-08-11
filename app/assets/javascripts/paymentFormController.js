(function(){
  var paymentFormController = function($scope, $q) {

  $scope.tokenize = function() {
    return $.when(function() {
      return setTimeout(3000,function(){return true});
      
    });
  };



  };

app.controller('paymentFormController',['$scope','$q', paymentFormController]);
  })();