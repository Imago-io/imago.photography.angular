class Header extends Directive

  constructor: ($rootScope) ->

    return {

      templateUrl: '/app/header/header.html'
      controller: 'headerController as header'
      link: (scope) ->

        watcher = $rootScope.$on 'settings:loaded', (evt, data) ->
          scope.tenantSettings = data
          watcher()

        console.log 'settings loaded'

    }

class HeaderController extends Controller

  constructor: (@$rootScope) ->

  activate: ->
    @$rootScope.navActive = !@$rootScope.navActive
