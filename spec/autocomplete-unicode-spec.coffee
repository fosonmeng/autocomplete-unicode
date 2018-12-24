packagesToTest =
  gfm:
    name: 'language-gfm'
    file: 'test.md'

describe "Unicode autocompletions", ->
  [editor, provider] = []

  getCompletions = ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = cursor.getBufferPosition()
    prefix = editor.getTextInRange([start, end])
    request =
      editor: editor
      bufferPosition: end
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
    provider.getSuggestions(request)

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('autocomplete-unicode')

    runs ->
      provider = atom.packages.getActivePackage('autocomplete-unicode').mainModule.getProvider()

    waitsFor -> provider.unicodes.length > 0

  Object.keys(packagesToTest).forEach (packageLabel) ->
    describe "#{packageLabel} files", ->
      beforeEach ->
        atom.config.set('autocomplete-unicode.scopes', '.source.gfm')
        atom.config.set('autocomplete-unicode.prefix', ',u')

        waitsForPromise -> atom.packages.activatePackage(packagesToTest[packageLabel].name)
        waitsForPromise -> atom.workspace.open(packagesToTest[packageLabel].file)
        runs -> editor = atom.workspace.getActiveTextEditor()

      it "autocompletes unicode with a proper prefix", ->
        editor.setText """
          ,us
        """
        editor.setCursorBufferPosition([0, 3])
        completions = getCompletions()
        expect(completions[ 1].text).toBe '⛷'
        expect(completions[ 0].replacementPrefix).toBe ',u'