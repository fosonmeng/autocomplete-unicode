fs = require('fs')
path = require('path')
fuzzaldrin = require('fuzzaldrin')
getUnicodeTable = require('./get-unicode-table')

module.exports =
  selector: ''
  
  prefixLength: 0
  wordRegex: null
  unicodes: []

  loadTable: ->
    getUnicodeTable().then (unicodes) => 
      @unicodes = unicodes
  
  updateConfig: ->
    @selector = atom.config.get('autocomplete-unicode.scopes')
    prefix = atom.config.get('autocomplete-unicode.prefix')
    @prefixLength = prefix.length
    @wordRegex = new RegExp(prefix + '?[\\w\\d_\\+-]+$')

  getSuggestions: ({editor, bufferPosition}) ->
    prefix = @getPrefix(editor, bufferPosition)
    return [] unless prefix?.length > @prefixLength
    
    unicodes = @getUnicodeSuggestions(prefix)

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(@wordRegex)?[0] or ''

  getUnicodeSuggestions: (prefix) ->
    words = fuzzaldrin.filter(@unicodes, prefix.slice(@prefixLength))
    for word in words
      [desc, char] = word.split('@@')
      if desc and char
        {
          text: char
          replacementPrefix: prefix
          rightLabel: desc.toUpperCase()
        }