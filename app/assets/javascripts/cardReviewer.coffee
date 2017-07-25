cardReviewer = ($scope, server,$timeout,statusPrinter,cardService, math)->
  cardPath = CARD_PATH
  # cards_path is a global that is set
  # in the template
  $scope.ready = false
  $scope.cards = null
  $scope.isMaxPage = false
  $scope.currentCard = null
  $scope.loading = true

  $scope.addPage = (callback)->
    $scope.pageNum++
    pagePath = cardPath + "&page="+$scope.pageNum
    newCards = []
    server.getCards(cardPath, {'page': $scope.pageNum}, newCards)
      .then (obj)->
        if (newCards.length is 0)
          $scope.isMaxPage = true
        pushCards(newCards, callback)

  getCurrentCard = -> $scope.cards[$scope.index]


  pushCards = (cards, callback)->
    $scope.loading = false
    for card in cards
      $scope.cards.push(card)
      card.processed = false
      card.backVisible = false
    $timeout()
    math.typeset()
    if (callback?)
      callback()


  $scope.isButtonVisible = -> $scope.buttonVisible[$scope.cardid]

  removeCurrentCard = ->
    $scope.currentCard.processed = true
    if $scope.index < $scope.cards.length - 1
      nextIndex = $scope.index
      if !$scope.isMaxPage and $scope.index + 4 >= $scope.cards.length
        $scope.addPage()
    else if ($scope.index > 0)
      nextIndex = $scope.index - 1
    else
      nextIndex = null
    $scope.cards.splice($scope.index, 1)
    if nextIndex is not null
      $scope.index = nextIndex

  $scope.deleteCard = ->
    cardId = $scope.currentCard.id
    if confirm("Delete card #{cardId}?")
      removeCurrentCard()
      server.deleteCard cardId, ->
        statusPrinter.print("Successfully deleted card #{cardId}.")

  $scope.tooSoon = ->
    cardId = getCurrentCard().id
    if confirm("This review of card #{cardId} was too soon?")
      removeCurrentCard()
      server.process cardId, "too_soon", ->
        msg = "Saved: this review of #{cardId} was marked as too soon."
        statusPrinter.print(msg)


  $scope.tooLate = ->
    cardId = getCurrentCard().id
    if confirm("This review of card #{cardId} was too late?")
      removeCurrentCard()
      server.process cardId, "too_late", ->
        statusPrinter.print("Saved: this review for #{cardId} was marked as too late.")

  $scope.gotIt = ->
    cardId = $scope.currentCard.id
    removeCurrentCard()
    server.gotIt cardId, ->
      statusPrinter.print("Saved: reviewed card #{cardId}.")

  $scope.memorizedIt = ->
    cardId = $scope.currentCard.id
    removeCurrentCard()
    server.memorizedIt cardId, ->
      statusPrinter.print("Saved: memorized card #{cardId}.")

  $scope.edit = ->
    $event.stopPropagation()
    url = "/flashcards/" +$scope.currentCard.id + "/edit"
    window.location.href = url

  update = ->
    $scope.currentCard = $scope.cards[$scope.index]
    $scope.processed = $scope.currentCard.processed
    $scope.attachedKeywords = $scope.currentCard.keywords


  $scope.$watch 'index',->
    if typeof($scope.index) is 'number' && $scope.index < $scope.cards.length
      update()

  $scope.$watchCollection 'cards', ->
    if typeof($scope.index) is 'number' && $scope.index < $scope.cards.length
      update()

  $scope.toggle = ->
    $scope.currentCard.backVisible = !$scope.currentCard.backVisible

  initIndex = ->
    $scope.index = 0
    if $scope.cards.length > 0
      $scope.currentCard = $scope.cards[$scope.index]
    else
      $scope.currentCard = null

  $scope.loading = true
  $scope.cards = []
  $scope.pageNum = 0
  $scope.addPage(initIndex)
  $scope.ready = true

reviewerDependencies = [
  '$scope',
  'server',
  '$timeout',
  'statusPrinter',
  'cardService',
  'math',
  cardReviewer
]
window.app.controller('cardReviewer',reviewerDependencies)