browseboxController = ($scope)->
  $scope.index = 0;
  $scope.left = ->
    if ($scope.index > 0)
      $scope.index--;
  $scope.right = ->
    if $scope.index < $scope.array.length - 1
      $scope.index++;
      if (!$scope.isMaxLoaded && $scope.index + 4 >= $scope.array.length)
        $scope.more();
  $scope.leftExists = ->
    return ($scope.index > 0)

  $scope.rightExists = ->
    if $scope.array is null
      return false;
    else
      return ($scope.index < $scope.array.length - 1);
  $scope.$watchCollection 'array', ->
    if $scope.array is null
      $scope.empty = true
    else
      $scope.empty = ($scope.array.length is 0)

browseboxDirective = ->
  return {
    transclude: {
      card: 'cardSlot',
      buttons: 'buttonSlot'
    },
    controller: ['$scope',browseboxController],
    templateUrl: '/templates/browsebox.html',
    scope: {
      array: '=',
      more: '&',
      isMaxLoaded: '=',
      index: '=',
      loading: '='
    }
  }
window.app.directive('browsebox',[browseboxDirective]);