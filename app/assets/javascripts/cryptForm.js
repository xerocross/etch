(function(){
  "use strict"
  var calCryptForm = function($parse, crypt) {
    var cryptFormDef = {
      compile: function(tElement, tAttrs, transclude) {
        
        var submitFnc = $parse(tAttrs['calCryptSubmit']);
        var decryptInputs = function(element) {
          var inputArray = element.find("[cal-crypt-input]").get();
          for (var i = 0; i < inputArray.length; i++) {
             $(inputArray).val(crypt.decrypt($(inputArray).val()));
          }
        }
        decryptInputs(tElement);  
        var encryptInputs = function(element) {
          var inputArray = $(element).find("[cal-crypt-input]").get();
          for (var i = 0; i < inputArray.length; i++) {
            var plaintext = $(inputArray[i]).val();
            var ciphertext = crypt.encrypt(plaintext);
            $(inputArray[i]).val(ciphertext);
          }
        };
        return function(scope, element, attr) {
          $(element).on('submit',function(event) {
            encryptInputs(element[0]);

          });
        };
      }
    };
    return cryptFormDef;
  };
  
  app.directive('calCryptForm',['$parse','crypt',calCryptForm]);
})();