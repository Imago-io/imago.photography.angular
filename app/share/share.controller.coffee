class Share extends Controller

  constructor: (@$http, @$location, $state, @imagoModel, promiseData) ->

    unless $state.params.parameter
      return @$location.path('/')

    @status = 'pristine'
    @showfullsize = {}

    @resolutions = [
      {
        'name': 'High resolution'
        'resolution': 'high'
      }
      {
        'name': 'Low resolution'
        'resolution': 'low'
      }
    ]

    for data in promiseData
      @data = data
      break

    unless @data.path
      return $state.go 'contact'

    @breadcrumb = []
    path = ''
    for item, i in @data.path.split('/')
      continue if item is ''
      path = path + '/' + item
      @breadcrumb.push {name: item, path: path} unless item in ['','public']

  togglePrompt: ->
    @downloadPrompt = !@downloadPrompt
    return unless @downloadPrompt
    @downloadFormData or= {}
    @downloadFormData.resolution = 'low'

  download: (validForm) =>
    return unless validForm
    toDownload =
      assets      :  (asset._id for asset in @data.assets)
      email       :  @downloadForm.data.email
      resolution  :  @downloadForm.data.resolution

    @status = 'requested'

    @$http.post("#{@imagoModel.host}/api/assets/download", toDownload)

  clickOnAsset: (asset) ->
    if asset.count
      return @$location.path(asset.path)

    @fullsizeslider or= {}
    @fullsizeslider.show  = true
    @fullsizeslider.asset = asset

  escWatch: (e) ->
    return unless e.which is 27
    @showfullsize.show = false
