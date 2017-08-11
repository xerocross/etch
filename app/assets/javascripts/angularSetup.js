var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');




var review = function($scope, $http, server) {
        "use strict";
        $scope.cardObjects = [];
        $scope.init = function() {
            $scope.cardIds = null;
            $scope.loading = true;
            server.getCardsDue(function(obj){
                $scope.loading = false;
                $scope.cardIds = obj.data;
                $scope.numCards = obj.data.length;
                $scope.cardsLoaded = $scope.cardIds.length;
                console.log($scope.numCards);
                $scope.index = 0;
                $scope.cardid = $scope.cardIds[$scope.index];
                $scope.load();
            });
            
        };
        $scope.init();
        
        $scope.load = function() {
            $scope.cardIds.forEach(function(id){
                server.getCard(id, function(obj){
                    $scope.cardObjects.push(obj.data);
                });
                
            });
        };
        
        $scope.empty = function() {
            return ($scope.cardIds !== null && $scope.cardIds.length ===0);
        }
        
        $scope.left = function() {
            console.log("left");
            if ($scope.index > 0)
                $scope.index--;
            $scope.cardid = $scope.cardIds[$scope.index];
        };
        $scope.right = function() {
            console.log("right");
            if ($scope.index < $scope.cardsLoaded - 1)
                $scope.index++;
            $scope.cardid = $scope.cardIds[$scope.index];
        };
        
        $scope.gotIt = function() {
            console.log("got " + $scope.cardid);
            server.gotIt($scope.cardid);
        };
        $scope.tooSoon = function() {
            console.log("tooSoon " + $scope.cardid);
        };
        $scope.forgotIt = function() {
            console.log("forgot " + $scope.cardid);
        };
    };


    var password = localStorage.password;
    var encrypt = function(plaintext) {
        var ciphertext = base64_encode(AESEncryptCtr(plaintext, password, 256));
        return "!" + ciphertext + "!";
    };
    var decrypt = function(input) {
        var re = /!([a-zA-Z0-9+/=]*)!/g;
        var match = re.exec(input);
        if (match === null)
            return input;
        var ciphertext = match[1];
        var plaintext = AESDecryptCtr(base64_decode(ciphertext), password, 256);
        return plaintext;
    };
    

    var excerpt = function(text) {
        var returnString = "";
        var wordArray = text.split(" ");
        var wordIndex = 0;
        while (wordIndex < wordArray.length && returnString.length < 50)
        {
            returnString+= wordArray[wordIndex] + " ";
            wordIndex++;
        }
        if (returnString.length > 50)
            returnString = returnString.substr(0,60);
        return returnString;
    };

    var app = angular.module('callisto');
    app.filter('decrypt', function() {
        return function(ciphertext) {
            return decrypt(ciphertext);
        };
    });

    app.filter('toString', function() {
        return function(arr) {
            var str = "";
            for (var i = 0; i < arr.length - 1; i++)
                str+= "\"" + arr[i].toString() + "\", "; 
            if (arr.length > 0)
                str+= "\"" + arr[arr.length - 1].toString() +  "\"";
            var textArray = []
            for (var i = 0; i < arr.length; i++)
                textArray[i] = arr[i].toString();
            return JSON.stringify(textArray);
        };
    });


    (function(){

        if (!localStorage) {
            alert("Etch cannot function on a browser without local storage.  Etch recommends using a modern browser.");
        }

        var keyService = function() {

            this.setKey = function(key) {
                localStorage.setItem('password', key);   
            };

            this.getKey = function() {
                var fromStorage = localStorage.getItem('password');
                if (typeof(fromStorage) === 'string')
                    return fromStorage;
                else
                    return "";
            };
        };
        angular.module('callisto').service('keyService',keyService);
    })()


    var crypt = function(keyService) {
    "use strict";
        this.encrypt = function(plaintext) {
          password = keyService.getKey();
          if (!plaintext || plaintext === null || plaintext == "")
            return plaintext;
          return encrypt(plaintext);
        };
        this.decrypt = function(ciphertext) {
            password = keyService.getKey();
            return decrypt(ciphertext); 
        }
    };
    app.service('crypt',['keyService',crypt]);
    
    app.service('excerpt',function(){
        this.excerpt = excerpt; 
    });


    var calDecrypt = function($parse, crypt) {
        return {
            compile : function(element, attr) {
                var ciphertext = $(element).html();
                $(element).html(crypt.decrypt(ciphertext));
            }
        };
    };
    angular.module('callisto').directive('calDecrypt',['$parse', 'crypt', calDecrypt]);


    var swipeLeft = function($parse) {
        return {
            //compile : function(element, attr) {
            //    var ciphertext = $(element).html();
            //    $(element).html(crypt.decrypt(ciphertext));
            //}
            link : function($scope, element, attr) {
                $(element).on('swipe',function(){
                    alert("left");
                });
            }
        };
    };
    angular.module('callisto').directive('swipeLeft',['$parse', swipeLeft]);

    
    angular.module('callisto').filter('excerpt',function() {
        return excerpt;
    });

    var entityMap = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;',
      '/': '&#x2F;',
      '`': '&#x60;',
      '=': '&#x3D;'
    };

    function escapeHtml (string) {
      return String(string).replace(/[&<>"'`=\/]/g, function (s) {
        return entityMap[s];
      });
    }
    var calExcerpt = function(excerpt) {
        return {
            scope : {},
            priority : 1,
            link : function(scope, element, attr) {
                var longtext = $(element).html();
                $(element).html(escapeHtml(excerpt.excerpt(longtext)));
            }
        };
    };
    angular.module('callisto').directive('calExcerpt', ['excerpt',calExcerpt]);
    
    var compareTo = function() {
        return {
            require: "ngModel",
            scope: {
                otherModelValue: "=compareTo"
            },
            link: function(scope, element, attributes, ngModel) {

                ngModel.$validators.compareTo = function(modelValue) {
                    return modelValue == scope.otherModelValue;
                };

                scope.$watch("otherModelValue", function() {
                    console.log('some change');

                    ngModel.$validate();
                });
            }
        };
    };

    app.directive("compareTo", compareTo);


    app.filter('encrypt', function() {
        return function(plaintext) {
            return encrypt(plaintext);
        };
    });
  
(function(){
    var alert = function($scope,server) {

        $scope.setSeen = function(id) {
            server.postAlert(id);
            console.log("set seen: " + id);
        }


    }
    angular.module('callisto').controller('alert',['$scope','server',alert]);
})();
