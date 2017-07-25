questionBlankController = ($scope)->
  $scope.reveal = false
  $scope.revealAnswer = ->
    $scope.reveal = true
  $scope.hideAnswer = ->
    $scope.reveal = false
questionBlank = ->
  return {
    scope: {
      answer: '@',
      blankText: '@'
    },
    template: "<span class='q-group'><span class='blank' ng-show='!reveal' ng-click='revealAnswer()'><strong>{{blankText}}</strong></span><span class='answer' ng-show='reveal' ng-click='hideAnswer()'><span ng-bind-html='answer'></span></span></span>",
    controller: ['$scope', questionBlankController]
  };
window.app.directive('questionBlank',[questionBlank]);