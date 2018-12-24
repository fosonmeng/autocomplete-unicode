fs = require('fs')
path = require('path')
download = require('download')

getUCDContent = () ->
  new Promise (resolv, rej) ->
    ucdPath = path.resolve(__dirname, '../ucd.txt')
    try
      content = fs.readFileSync(ucdPath)
      resolv(content.toString())
    catch err
      download('https://www.unicode.org/Public/11.0.0/ucd/NamesList.txt')
      .then (data) ->
        fs.writeFileSync(ucdPath, data)
        resolv(data.toString())
      .catch (e) -> rej(e)

getUnicodeTable = () ->
  getUCDContent().then (ucdContent) ->
    table = []
    for line in ucdContent.split('\n')
      [code, desc] = line.split('\t')
      if code and code.length is 4 and desc
        table.push desc.toLowerCase().replace(/ /g, '_') + '@@' + String.fromCharCode(parseInt(code, 16))
    return table

module.exports = getUnicodeTable