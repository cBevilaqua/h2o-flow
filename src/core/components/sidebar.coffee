{ lift, link, signal, signals } = require("../modules/dataflow")

outline = require('./outline')
browser = require('./browser')
clipboard = require('./clipboard')


exports.init = (_, cells) ->
  _mode = signal 'outline'

  _outline = outline.init _, cells
  _isOutlineMode = lift _mode, (mode) -> mode is 'outline'
  switchToOutline = -> _mode 'outline'

  _browser = browser.init _
  _isBrowserMode = lift _mode, (mode) -> mode is 'browser'
  switchToBrowser = -> _mode 'browser'

  _clipboard = clipboard.init _
  _isClipboardMode = lift _mode, (mode) -> mode is 'clipboard'
  switchToClipboard = -> _mode 'clipboard'


  link _.ready, ->

    link _.showClipboard, ->
      switchToClipboard()

    link _.showBrowser, ->
      switchToBrowser()

    link _.showOutline, ->
      switchToOutline()

  outline: _outline
  isOutlineMode: _isOutlineMode
  switchToOutline: switchToOutline
  browser: _browser
  isBrowserMode: _isBrowserMode
  switchToBrowser: switchToBrowser
  clipboard: _clipboard
  isClipboardMode: _isClipboardMode
  switchToClipboard: switchToClipboard
 
