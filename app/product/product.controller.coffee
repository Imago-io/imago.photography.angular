class ProductController extends Controller

  constructor: (@$state, $rootScope, @$scope, @imagoProduct, @promiseData, imagoCart) ->

    # set default tab
    @tab = 'information'

    if imagoCart.currency
      return @getProduct()

    watcher = $rootScope.$on 'imagocart:currencyloaded', (evt, data) =>
      @getProduct()
      watcher()

  getProduct: ->
    @optionsWhitelist = [
      {
        'name'  : '{{fieldName}}'
        'color' : '{{fieldColor}}'
      }
    ]

    optionsProduct =
      optionsWhitelist : @optionsWhitelist
      lowStock  : 3

    for item in @optionsWhitelist
      continue unless @$state.params[item.name]
      optionsProduct[item.name] = @$state.params[item.name]

    for item in @promiseData
      @data = item
      @productItem = new @imagoProduct(item.variants, optionsProduct)
      break

    toWatchProperties = []
    createWatchFunc = (name) =>
      toWatchProperties.push(=> @productItem[name])

    for item in @optionsWhitelist
      continue unless item.name
      createWatchFunc(item.name)

    @$scope.$watchGroup toWatchProperties, (value) =>
      @changePath()

  changePath: ->
    parameters = {}
    for item in @optionsWhitelist
      parameters[item.name] = @productItem[item.name]
      changed = true if @productItem[item.name] isnt @$state.params[item.name]

    return unless changed

    @$state.go 'product', parameters,
      'notify': false
      'location': 'replace'
