(function(){
  var paymentMethodForm = function($scope) {
    
    $scope.email = EMAIL;
    $scope.targetForm;
    

    $scope.checkout = function(e) {
      e.preventDefault();
      $scope.targetForm = e.target;
      $.getScript("https://checkout.stripe.com/checkout.js").done(function(){
        
            var handler = StripeCheckout.configure({
            key: STRIPE_KEY,
            image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
            locale: 'auto',
            token: function(token) {
              $scope.paymentToken = token.id;
              $scope.$apply();
              $scope.targetForm.submit();
              // You can access the token ID with `token.id`.
              // Get the token ID to your server-side code for use.
              }
            });
            $scope.targetForm = e.target;
            handler.open({
              name: 'XeroCross Etch',
              description: '30 day subscription, recurring',
              amount: 00,
              zipCode: true,
              allowRememberMe: false,
              panelLabel: "Update Payment Info",
              email: $scope.email
            });
        
        
      });

    }
  };
  app.controller('paymentMethodForm',['$scope',paymentMethodForm]);
})();