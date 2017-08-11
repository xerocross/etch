(function(){
  var brain = function($scope, $http) {
    $scope.c = LEARNING_CONSTANTS;
    $scope.prog = "";
    
    $scope.$watchCollection('c',function() {
      
      for (var i = 0; i < $scope.c.length; i++)
        $scope.c[i] = parseFloat($scope.c[i]);
      
      var req = {
          method: 'POST',
          url : '/brain/prognosticate',
          data : {learning_constants: $scope.c},
          headers: {
             'X-CSRF-Token': AUTH_TOKEN
          },
      };

      
      $http(req).then(function(dataObj) {
        console.log(dataObj);
        console.log(dataObj.data.prognosticate);
        var prog = dataObj.data.prognosticate;
        $scope.prog = prog;
      });
      
    });

  }
  app.controller('brain',['$scope','$http',brain]);
})();