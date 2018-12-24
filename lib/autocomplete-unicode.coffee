config = require('./config')
provider = require('./unicode-provider')
{ CompositeDisposable } = require('atom')

module.exports =
  config: config
  subscriptions: null
  
  activate: ->
    @subscriptions = new CompositeDisposable()
    provider.loadTable()
    provider.updateConfig()
    
    observingConfigs = [
      'autocomplete-unicode.prefix',
      'autocomplete-unicode.scopes'
    ]
    
    for config in observingConfigs
      @subscriptions.add atom.config.observe(config, () ->
        provider.updateConfig())

  getProvider: -> provider
  
  deactivate: ->
    @subscriptions.dispose()