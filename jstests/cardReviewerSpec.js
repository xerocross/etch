describe("cardReviewerSpec", function () {
  beforeEach(module('callisto'));

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
    mockServer.page = 0;
    
    mockServer.pageCards = [];
    mockServer.pageCards[0] = [{id:0},{id:1},{id:2}];
    mockServer.pageCards[1] = [{id:3},{id:4},{id:5}];
    mockServer.pageCards[2] = [];
    
    mockServer.getCards = function(path, query, container) {
      
      deferred = $q.defer();
      deferred.resolve();
      
      var pageCards = mockServer.pageCards[mockServer.page];
      
      for (var i = 0; i < pageCards.length; i++) {
        container.push(pageCards[i])
      }
      mockServer.page++;

      return deferred.promise
    };
    mockServer.gotIt = function() {
      mockServer.gotItWasCalled = true;
    };
    mockServer.tooSoon = function() {
    };
    mockServer.tooLate = function() {
    };
    mockServer.deleteCard = function() {
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
    // explicit call to $scope.$digest() is necessary
    // so that _then_ is called after getCards promise
    // is resolved
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


  describe("When you call tooSoon on a card", function () {
    it("should remove the card from scope.cards", inject(function () {
      $scope.$digest();
      var initLength = $scope.cards.length
      $scope.tooSoon();
      expect($scope.cards.length).toBe(initLength - 1)
    }));
  });
  describe("When you call tooLate on a card", function () {
    it("should remove the card from scope.cards", inject(function () {
      $scope.$digest();
      var initLength = $scope.cards.length
      $scope.tooLate();
      expect($scope.cards.length).toBe(initLength - 1)
    }));
  });
  describe("When you call gotIt on a card", function () {
    it("should remove the card from scope.cards", inject(function () {
      $scope.$digest();
      var initLength = $scope.cards.length
      $scope.gotIt();
      expect($scope.cards.length).toBe(initLength - 1)
    }));
  });
  describe("When you call deleteCard on a card", function () {
    it("should remove the card from scope.cards", inject(function () {
      $scope.$digest();
      var initLength = $scope.cards.length
      $scope.deleteCard();
      expect($scope.cards.length).toBe(initLength - 1)
    }));
  });

  describe("When you process and remove a card...", function () {
    describe("if it is the last card available to load", function () {
      it("should step backward to previous", inject(function () {
        $scope.isMaxPage = true;
        $scope.$digest();
        var initLength = $scope.cards.length
        $scope.index = initLength - 1;
        $scope.$digest();
        $scope.gotIt();
        $scope.$digest();
        expect($scope.index).toBe(initLength - 2);
      }));
      
    });
    describe("and $scope.index = $scope.cards.length - 1 but more cards can be loaded", function () {
      it("should not increment the card index", inject(function () {
        $scope.$digest();
        var initLength = $scope.cards.length
        $scope.index = initLength - 1;
        $scope.$digest();
        $scope.gotIt();
        $scope.$digest();
        expect($scope.index).toBe(initLength - 1);
      }));
      it("should load a new page of cards", inject(function () {
        $scope.$digest();
        spyOn($scope, "addPage");
        var initLength = $scope.cards.length
        $scope.index = initLength - 1;
        $scope.$digest();
        console.log("current card is " + $scope.currentCard.id);
        $scope.gotIt();
        expect($scope.addPage).toHaveBeenCalled();
      }));
    });

    describe("and $scope.index < $scope.cards.length - 1", function () {
      it("should not increment the card index", inject(function () {
        $scope.$digest();
        $scope.index = 1;
        $scope.$digest();
        $scope.gotIt();
        $scope.$digest();
        expect($scope.index).toBe(1);
      }));
    });
    
    describe("if it loads a new page of cards and its nonempty", function () {
      it("should still have $scope.isMaxPage equal to false", inject(function () {
        
        $scope.$digest();
        // load the first page
        $scope.index = $scope.cards.length;
        $scope.gotIt();
        $scope.$digest();
        // load the second page
        expect($scope.isMaxPage).toBe(false);
      }));
    });
    
    
    describe("if it loads all of the cards until receiving an empty page from the serverService", function () {
      it("should set $scope.isMaxPage to true", inject(function () {
        
        $scope.$digest();
        // load the first page
        $scope.index = $scope.cards.length;
        $scope.gotIt();
        $scope.$digest();
        // load the second page
        $scope.index = $scope.cards.length;
        $scope.gotIt();
        $scope.$digest();
        // load the third, empty page
        expect($scope.isMaxPage).toBe(true);
      }));
      
    });
    
  });
  
});