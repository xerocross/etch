(function(){
  
  var promiseSubmit = function($parse) {
    return {
      scope: {'paymentCard':'=',
              'stripe':'=',
              'success':'&',
              'failure':'&',
              'promise':'$'
      },
      compile: function(tElement, tAttrs, transclude){
        fnc = $parse(tAttrs['promiseFunction'])
        return function(scope, element, attr) {
          $(element).on('submit',function(){
          
            promise().then(success, failure);
          
          });
        
        } 
      }
    };
  }
          
  app.directive('promiseSubmit',['$parse', promiseSubmit]);
  
  
  
  var cardInput = function() {
    return {
      scope: {'paymentCard':'=',
              'stripe':'='
             },
      compile: function(tElement, tAttrs, transclude) {
        
        return function(scope, element, attr) {
          scope.stripe = Stripe('pk_test_K0GyDMMY9b7asnt0AUExelby');
          var elements = scope.stripe.elements();
          scope.paymentCard = elements.create('card');
          var cardDOM;
          scope.tokenReady = false;
          scope.checkingToken = false;
          $(scope.paymentCard).addClass("form-control");
          cardDOM = element[0].querySelector("#card-element");
          scope.paymentCard.mount(cardDOM);
        };  
      }
    }
  };
  app.directive('cardInput',[cardInput]);
})();