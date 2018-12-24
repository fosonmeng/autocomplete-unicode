options = {
  'prefix': {
    type: 'string',
    default: ',u'
  },
  'scopes': {
    type: 'string',
    default: '''
.source.gfm, .text.md, .text.restructuredtext, .text.html, .text.slim, 
.text.plain, .text.git-commit, .comment, .string, .source.emojicode
'''
  }
}

module.exports = options