(function(){   
    var encryptionKeySetter = function($scope, keyService) {
        "use strict";
        $scope.isSet = false;
        $scope.key = null;
        $scope.keyStatus = "";
        $scope.isUpdateKey = {'val': false};
        $scope.newKey = "";
        
        var key = keyService.getKey();
        

        if (key && key !== undefined) {
            $scope.key = key;
            $scope.isSet = true;
            $scope.keyStatus = "key found in local storage";
        } else {
            $scope.keyStatus = "please set key";
        }
        


        $scope.save = function() {
            keyService.setKey($scope.key);//localStorage.setItem('password', $scope.key);
        
        }
        $scope.update = function() 
        {
            //$event.preventDefault();
            console.log("key updated");
            $scope.keyStatus = "key updated";
            $scope.key = $scope.newKey;
            $scope.save();
            $scope.newKey = undefined;
        }

        
        $scope.$watch('newKey',function(){
            
        });
        
        $scope.$watch('isUpdateKey.val',function(){
            console.log($scope.isUpdateKey.val);
            
        });
        

    };
    app.controller('encryptionKeySetter',['$scope','keyService',encryptionKeySetter]);
})();