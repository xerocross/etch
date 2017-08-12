describe("Controllers", function () {
  beforeEach(module('callisto'));

  describe("WorkoutController", function () {
    var ctrl, $scope;
    beforeEach(inject(function ($rootScope, _$controller_, _$timeout_, $q) {
      CARD_PATH = "/flashcards";
      $scope = $rootScope.$new();
      $controller = _$controller_;
      $timeout = _$timeout_;
      
      
      mathService = {}
      mathService.typeset = function(){}
      
      
      mockServer = {};
      mockServer.gotItWasCalled = false;
      mockServer.tooSoonWasCalled = false;
      mockServer.getCards = function(path, query, container) {
        deferred = $q.defer();
        deferred.resolve();
        container.push({id: 0})
        container.push({id: 1})
        
        return deferred.promise
      };
      mockServer.gotIt = function() {
        mockServer.gotItWasCalled = true;
      };
      mockServer.tooSoon = function() {
      };
      mockServer.tooLate = function() {
      };
      
      alertService = {}
      alertService.confirm = function(text) {
        console.log(text);
        return true;
      }
      
      ctrl = $controller('cardReviewer', {
          $scope: $scope,
          serverService: mockServer,
          $timeout: $timeout,
          statusPrinter: {},
          cardService: {}, 
          mathService: mathService,
          alertService: alertService
      });
    }));

    it("should pass gotIt to server service", inject(function () {
      spyOn(mockServer,"gotIt");
      $scope.$digest();
      $scope.gotIt();
      expect(mockServer.gotIt).toHaveBeenCalled();
    }));
    
    it("should pass tooSoon to server service", inject(function () {
      spyOn(mockServer,"tooSoon");
      $scope.$digest();
      $scope.tooSoon();
      expect(mockServer.tooSoon).toHaveBeenCalled();
    }));
    
    it("should pass tooLate to server service", inject(function () {
      spyOn(mockServer,"tooLate");
      $scope.$digest();
      $scope.tooLate();
      expect(mockServer.tooLate).toHaveBeenCalled();
    }));
    
    
  });
});