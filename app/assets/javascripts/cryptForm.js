(function(){
  "use strict"
  /*
  var calCryptForm = function($parse, crypt) {
    var cryptFormDef = {
      compile: function(tElement, tAttrs, transclude) {
        var action = tAttrs['action'];
        var method = tAttrs['method'];
        var proxyForm = document.createElement("form");
        proxyForm.setAttribute('action',action);
        proxyForm.setAttribute('method',method);
        document.body.appendChild(proxyForm);
        //$(proxyForm).hide();
        
        var duplicateInputs = function(element) {
          var childrenArray = $(element[0]).children().get();
          
          for (var i = 0; i < childrenArray.length; i++) {
            var child = childrenArray[i];
            var clone = child.cloneNode(true);
            clone['original'] = child;
            console.log("clone.original was set to:");
            console.log(clone['original']);
            proxyForm.appendChild(clone);
            
          }
          var inputsArray = $(proxyForm).find("textarea").get();
          for (var i = 0; i < inputsArray.length; i++) 
          {
            
            //var original = $(element[0]).find(child.name).get()[0];
            
            var child = inputsArray[i];
            //console.log(child.original);
            //$(child).val($(original).val());
            alert("name: " + child.id  + "clone value: " + $(child).val());
          }
          
          
        };
        var submitFnc = $parse(tAttrs['calCryptSubmit']);
        var decryptInputs = function(element) {
          var inputArray = element.find("[cal-crypt-input]").get();
          for (var i = 0; i < inputArray.length; i++) {
             $(inputArray).val(crypt.decrypt($(inputArray).val()));
          }
        }
        decryptInputs(tElement);  
        var encryptInputs = function(element) {
          inputArray = $(proxyForm).find("[cal-crypt-input]").get();
          for (var i = 0; i < inputArray.length; i++) {
            var plaintext = $(inputArray[i]).val();
            var ciphertext = crypt.encrypt(plaintext);
            alert("p: " + plaintext + "q: " + ciphertext);
            $(inputArray[i]).val(ciphertext);
          }
        };
        return function(scope, element, attr) {
          $(element).on('submit',function(event) {
            event.preventDefault();
            
            
            
            console.log("submit");
            duplicateInputs(element);
            //encryptInputs(element);
            console.log(proxyForm);
            //document.body.appendChild(proxyForm);
            //proxyForm.submit();
          });
        };
      }
    };
    return cryptFormDef;
  };
  */
  
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