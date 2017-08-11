(function(){
  var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
  var newUser = function($scope,$http,$timeout,keyService) {
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
        $scope.targetForm;

        
        
        console.log("email " +$scope.email);
        handler.open({
          name: 'XeroCross Etch',
          description: '30 day subscription, recurring',
          amount: 00,
          zipCode: true,
          allowRememberMe: false,
          panelLabel: "Subscribe ($0.00 today)",
          email: $scope.email
        });
      });
    }
  };
  app.controller('newUser',['$scope','$http','$timeout','keyService',newUser])
  
})();
  