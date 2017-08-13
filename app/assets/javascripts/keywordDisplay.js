(function(){
  var keywordDisplay = function($parse, $http, crypt) {
    var keywordDisplayDef = {
      scope: {},
      template: "<p><span ng-repeat=\"keyword in keywords\">\n{{keyword.text}}<span ng-if=\"!$last\">; </span><span ng-if=\"$last\">.</span>\n</span></p>",
      compile: function(tElement, tAttrs, transclude) {
        console.log("keywordDisplay directive was used");
        return function($scope, element, attr) {
          $scope.keywords = [];
          var base_path = "/flashcards";
          console.log(attr);
          var path = base_path + '/' + attr.keywordDisplay + "/keywords.json";
          $http.get(path).then(function(obj){
            $scope.keywords = obj.data;
            for (var i = 0; i < $scope.keywords.length; i++) {
              $scope.keywords[i].text = crypt.decrypt($scope.keywords[i].text);
            }
          });
          
        };
      }
    };
    return keywordDisplayDef;
  };
  app.directive('keywordDisplay',['$parse','$http','crypt',keywordDisplay]);
})();