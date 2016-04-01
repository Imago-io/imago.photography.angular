class FullsizeSlider extends Directive

  constructor: ($rootScope, $timeout, $document) ->

    return {

      scope:
        trigger: '='
        assets: '='
        selected: '='
      replace: true
      transclude: true
      bindToController: true
      templateUrl: '/app/share/fullsize-slider.html'
      controller: 'fullsizeSliderController as fullsize'
    }



class FullsizeSliderController extends Controller

  constructor: ($rootScope, $timeout, $document, $scope, $element, $attrs) ->

    keyboardBinding = (evt) =>
      return unless evt.keyCode is 27
      @close(evt)
      $scope.$digest()

    @close = (ev) ->
      ev.stopPropagation()
      document.body.style.overflow = 'visible'
      @trigger = false

    watch = =>
      return @trigger

    preview = =>
      # console.log 'preview', @trigger
      # console.log 'assets, selected', @assets, @selected
      return unless @assets and @selected
      document.body.style.overflow = 'hidden'
      idx = _.findIndex(@assets, {'_id': @selected._id})
      idx = 0 if idx < 1
      $timeout -> $rootScope.$emit('fullsize-slider:change', idx)

    $scope.$watch watch, (trigger) ->
      preview() if trigger

    $scope.$on '$destroy', ->
      $document.off 'keydown', keyboardBinding

    $document.on 'keydown', keyboardBinding
