cardReviewer = ($scope, serverService, $timeout, statusPrinter, cardService, mathService, alertService)->
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
    serverService.getCards(cardPath, {'page': $scope.pageNum}, newCards)
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
    mathService.typeset()
    if (callback?)
      callback()


  $scope.isButtonVisible = -> $scope.buttonVisible[$scope.cardid]

  removeCurrentCard = ->
    LEAD_NUMBER = 4
    $scope.currentCard.processed = true
    nextIndex = $scope.index
    # when we remove the existing card
    # the index of the new current card
    # is the same numeric index, $scope.index
    # UNLESS the current card is the last
    # available card

    if $scope.isMaxPage and $scope.index == $scope.cards.length - 1
      nextIndex = $scope.index - 1
    else if !$scope.isMaxPage and $scope.index + LEAD_NUMBER >= $scope.cards.length
      $scope.addPage()
    $scope.cards.splice($scope.index, 1)
    $scope.index = nextIndex

  $scope.deleteCard = ->
    cardId = $scope.currentCard.id
    if alertService.confirm("Delete card #{cardId}?")
      removeCurrentCard()
      serverService.deleteCard cardId, ->
        statusPrinter.print("Successfully deleted card #{cardId}.")

  $scope.tooSoon = ->
    cardId = getCurrentCard().id
    if alertService.confirm("This review of card #{cardId} was too soon?")
      removeCurrentCard()
      serverService.tooSoon cardId, ->
        msg = "Saved: this review of #{cardId} was marked as too soon."
        statusPrinter.print(msg)

  $scope.tooLate = ->
    cardId = getCurrentCard().id
    if alertService.confirm("This review of card #{cardId} was too late?")
      removeCurrentCard()
      serverService.tooLate cardId, ->
        statusPrinter.print("Saved: this review for #{cardId} was marked as too late.")

  $scope.gotIt = ->
    cardId = $scope.currentCard.id
    removeCurrentCard()
    serverService.gotIt cardId, ->
      statusPrinter.print("Saved: reviewed card #{cardId}.")

  $scope.memorizedIt = ->
    cardId = $scope.currentCard.id
    removeCurrentCard()
    serverService.memorizedIt cardId, ->
      statusPrinter.print("Saved: memorized card #{cardId}.")

  $scope.edit = ->
    window.location.href = "/flashcards/#{$scope.currentCard.id}/edit"

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
  'serverService',
  '$timeout',
  'statusPrinter',
  'cardService',
  'mathService',
  'alertService'
  cardReviewer
]
window.app.controller('cardReviewer',reviewerDependencies)