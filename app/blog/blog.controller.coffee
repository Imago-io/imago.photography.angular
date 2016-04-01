class Blog extends Controller

  constructor: ($scope, $state) ->
    $scope.$on "$stateChangeSuccess", (ev, current, params) =>
      @tags = params.tag or ''
