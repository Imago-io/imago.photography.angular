class Header extends Directive

  constructor: ($rootScope) ->

    return {

      templateUrl: '/app/header/header.html'
      controller: 'headerController as header'

    }

class HeaderController extends Controller

  constructor: (@$rootScope) ->
