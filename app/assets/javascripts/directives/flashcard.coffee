flashcardDirective = ($timeout, math, multiChoiceRandomizer)->
  {
    scope: {
      card : '=',
      ready : '=',
      reveal : '='
    },
    priority: 10,
    templateUrl: '/templates/flashcard_study.html',
    link: (scope, element, attr)->
      if scope.card.macro is "multi_choice"
        multiChoiceRandomizer.generateChoices(scope.card)
      $timeout do ->
        math.scan(element.html())
  }

window.app.directive('flashcard',['$timeout','math', 'multiChoiceRandomizer', flashcardDirective])