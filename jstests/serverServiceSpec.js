describe("serverService", function(){
  beforeEach(module('callisto'));
  beforeEach(module(function($provide) {
    $provide.value("statusPrinter", {});
    $provide.value("cardService", {});
    
  }));
  beforeEach(inject(function (_server_, $httpBackend) {
    server = _server_;
    httpBackend = $httpBackend;
  }));
  
  it("should populate cards into container", function() {
    var container = [];
    httpBackend.whenGET("/flashcards.json").respond({
        data: [
          {
            id: 1
          }
          ,
          {
            id: 2
          }
        ]
    });
    
    server.getCards("/flashcards", {}, container).then(function(){
      expect(container.length).toBe(2);
    });
    
  });
  it("should delete cards", function() {
    httpBackend.expect("DELETE","flashcards/2.json");
    server.deleteCard(2,{});
  });
  
  it("should process cards 'got_it'", function() {
    httpBackend.expect("PATCH","flashcards/1/got_it");
    server.gotIt(1, null)
  });
  
  it("should process cards 'too_soon'", function() {
    httpBackend.expect("PATCH","flashcards/1/too_soon");
    server.tooSoon(1, null)
  });
  it("should process cards 'too_late'", function() {
    httpBackend.expect("PATCH","flashcards/1/too_late");
    server.tooLate(1, null)
  });

  
});