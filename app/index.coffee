angular.module 'app', [
  'angulartics'
  'angulartics.google.analytics'
  'angulartics.facebook.pixel'
  'ngAnimate'
  'ngTouch'
  'ui.router'
  'templatesApp'
  'angular-inview'
  'imago'
  'lodash'
  'ngSanitize'
  'headroom'
  'com.2fdevs.videogular'
  'com.2fdevs.videogular.plugins.controls'
  'com.2fdevs.videogular.plugins.overlayplay'
  'com.2fdevs.videogular.plugins.poster'
]

class Setup extends Config

  constructor: ($httpProvider, $provide, $sceProvider, $locationProvider, $compileProvider, $stateProvider, $urlRouterProvider, $analyticsProvider, imagoModelProvider) ->

    $sceProvider.enabled false

    # http defaults config START
    $httpProvider.useApplyAsync true

    $provide.decorator '$exceptionHandler', [
      '$delegate'
      '$window'
      ($delegate, $window) ->
        (exception, cause) ->
          if $window.trackJs
            $window.trackJs.track exception
          $delegate exception, cause
    ]

    if document.location.hostname is 'localhost'
      $analyticsProvider.developerMode true
    else
      $compileProvider.debugInfoEnabled false

    $analyticsProvider.firstPageview true
    $locationProvider.html5Mode true
    $urlRouterProvider.otherwise '/'

    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: '/app/gallery/gallery.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: '/home'

      .state 'contact',
        url: '/contact'
        templateUrl: '/app/contact/contact.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: "/contact"

      .state 'about',
        url: '/about'
        templateUrl: '/app/page/page.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel) ->
            imagoModel.getData
              path: "/about"

      .state 'list',
        url: '/:category'
        templateUrl: '/app/list/list.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel, $stateParams) ->
            imagoModel.getData
              path: "/#{$stateParams.category}"

      .state 'gallery',
        url: '/:category/:job'
        templateUrl: '/app/gallery/gallery.html'
        controller: 'page as page'
        resolve:
          promiseData: (imagoModel, $stateParams) ->
            imagoModel.getData
              path: "/#{$stateParams.category}/#{$stateParams.job}"





class Load extends Run

  constructor: ($rootScope, $state, $location, $timeout, tenantSettings, imagoUtils) ->
    document.documentElement.classList.remove('nojs')
    $timeout ->
      $rootScope.js = true
      $rootScope.mobile = imagoUtils.isMobile()
      $rootScope.mobileClass = if $rootScope.mobile then 'mobile' else 'desktop'
      FastClick.attach(document.body)

    $rootScope.toggleMenu = (status) ->
      if _.isUndefined status
        $rootScope.navActive = !$rootScope.navActive
      else
        $rootScope.navActive =  status

    $rootScope.$on '$stateChangeSuccess', (evt) ->
      $rootScope.urlPath = $location.path()
      state = $state.current.name.split('.').join(' ')
      path  = $rootScope.urlPath.split('/').join(' ')
      path = 'home' if path is ' '
      $rootScope.state = state
      $rootScope.path  = path
      $rootScope.toggleMenu(false)
      # ngProgress.done()

