(function(){
    "use strict";
    var pluck = function(array, attribute) {
        var returnArray = [];
        for (var i = 0; i < array.length; i++) {
            returnArray.push(array[i][attribute]);   
        }
        return returnArray;
    };

    var keywordSelector = function($scope, $http, crypt) {
        $scope.attachedKeywords = CARD.keywords;
        var Keyword = function(id, text){
          this.id = id;
          this.name = text;
          this.text = text;
          this.toString = function() {
              return this.text;
          }
        };
    
        $http.get('/keywords.json').then(function(dataObj){
          console.log(dataObj.data)
          $scope.availableKeywords = dataObj.data;
          for (var i = 0; i < $scope.availableKeywords.length; i++)
          {
            $scope.availableKeywords[i].text = crypt.decrypt($scope.availableKeywords[i].text); 
          }
        });

        
        for (var i = 0; i < $scope.attachedKeywords.length; i++) {
          $scope.attachedKeywords[i].text = crypt.decrypt($scope.attachedKeywords[i].text); 
        }
        $scope.$watchCollection('attachedKeywords',function(){
          $scope.$parent.attachedKeywords = $scope.attachedKeywords;
          console.log($scope.attachedKeywords);
          $scope.attachedkeywordIds = pluck($scope.attachedKeywords, 'id');
          $scope.$parent.attachedkeywordIds = $scope.attachedkeywordIds;
        });

        $scope.fromAutocompleteOnly = true;
        $scope.attachedKeywordsEncrypted = [];
        
        var populateEncrypted = function() {
          console.log("attachedkeywords");
          $scope.attachedKeywordsEncrypted = [];
          for (var i = 0; i < $scope.attachedKeywords.length; i++)
          {
            //$scope.attachedKeywords[i].id
            var keyword = {
              text : crypt.encrypt($scope.attachedKeywords[i].text)
            };
            if ($scope.attachedKeywords[i].id)
              keyword.id = $scope.attachedKeywords[i].id;
            $scope.attachedKeywordsEncrypted.push(keyword);
          }
          console.log($scope.attachedKeywordsEncrypted);
        };
        populateEncrypted();
        
      
        $scope.$watchCollection('attachedKeywords',populateEncrypted);
        
        var getKeywordById = function(id) {
            var key;
            for (var i = 0; i < $scope.availableKeywords.length; i++ ) {
                key = $scope.availableKeywords[i];
                if (key.id === id)
                    return key;
            };
            return null;
        };
        
        $scope.loadItems = function (query) {
          console.log(query);
            var pattern = new RegExp(query,"i");
            var filter = [];
            for (var i = 0; i < $scope.availableKeywords.length; i++)
                if ($scope.availableKeywords[i].text.match(pattern) !== null) {
                    filter.push($scope.availableKeywords[i]);
                }
            return {data: filter}
        };
        
    };
    app.controller('keywordSelector',['$scope','$http','crypt',keywordSelector]);
})();