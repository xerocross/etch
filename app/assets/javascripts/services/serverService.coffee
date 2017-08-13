AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
server = ($http, statusPrinter, cardService)->
  notifyOfFailure = ->
    alert("We encountered an error while communicating with the server.")
  
  @getCards = (path, query, container)->
    if (path.indexOf("?") > -1)
      urlString = path + "&";
    else 
      urlString = path + "?";

    queryParameters = Object.getOwnPropertyNames(query);

    for param in queryParameters
      if typeof(param) is 'string' and param.length > 0
        urlString += param + "=" + query[param] + "&"
      
    withCards = (cardsData)->
      cards = cardsData.data
      for card in cards
        card = cardService.parseCard(card)
        container.push(card)
      cardsData
      
      
    return $http.get(urlString).then withCards
    

  @deleteCard = (cardId, callback)-> 
    success = (dataObj)->
      if typeof(callback) is 'function' or typeof(callback) is 'object'
        callback();
    path = "/flashcards/#{cardId}.json";
    request =
      method: 'DELETE'
      url : path
      data : 
        '_method': 'DELETE' 
      headers: 
        'X-CSRF-Token': AUTH_TOKEN
      
    $http(request).then(success, notifyOfFailure);


  @process = (cardId, methodName, callback) ->
    success = ->
      if (typeof(callback) is 'function' or typeof(callback) is 'object')
        callback()
    pathBase = "flashcards"
    methodPath = "/flashcards/#{cardId}/#{methodName}"
    request =
      method: 'PATCH'
      url : methodPath
      headers:
        'X-CSRF-Token': AUTH_TOKEN
    $http(request).then(success, notifyOfFailure)

  @gotIt = (cardId, callback)-> this.process(cardId, "got_it", callback)
  @tooSoon = (cardId, callback)-> this.process(cardId, "too_soon", callback)
  @tooLate = (cardId, callback)-> this.process(cardId, "too_late", callback)
  
  @memorizedIt = (cardId, callback)-> process(cardId, "got_it", callback)
  return this
window.app.service('server',['$http','statusPrinter','cardService', server]);
window.app.service('serverService',['$http','statusPrinter','cardService', server]);
