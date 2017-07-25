flashcardShow = ->
  do  ->
    scope:
      card: '='
    templateUrl: '/templates/flashcard_show',
window.app.directive('flashcardShow',[flashcardShow])

flashcardPreview = ->
  do  ->
    scope:
      card: '='
    templateUrl: '/templates/flashcard_preview',
window.app.directive('flashcardPreview',[flashcardPreview])


customCompile = ($compile)->
  return (scope, element, attrs)->
    scope.$watch (scope)->
      #watch the 'compile' expression for changes
      return scope.$eval(attrs.compile)
    , (value)->
      # when the 'compile' expression changes
      # assign it into the current DOM
      element.html(value)

      # compile the new DOM and link it to the current
      # scope.
      # NOTE: we only compile .childNodes so that
      # we don't get into infinite loop compiling ourselves
      $compile(element.contents())(scope)

window.app.directive('compile', ['$compile', customCompile])

ajaxButton = ->
  {
    transclude: true,
    scope: {'busy' : '='},
    template: '<span class="glyphicon glyphicon-cloud-upload" ng-if="!busy"></span><span class="glyphicon glyphicon-hourglass" ng-if="busy"></span>&nbsp;<ng-transclude></ng-transclude>',
  }
window.app.directive('ajaxButton',[ajaxButton])

window.app.directive 'customTransclude', ->
  return {
    link: (scope, element, attrs, ctrls, transcludeFn)->
      if (!transcludeFn)
        throw new Error('Illegal use of custom-transclude directive! No parent directive that requires transclusion was found')
      transcludeFn scope, (clone)->
        element.empty().append(clone)
  }

loadingDirective = ->
  return {
    template: "<div class=\"spinner\"><span class=\"fa fa-gear fa-spin\"></span></div>"
  }
window.app.directive('loadingSpinner',[loadingDirective])