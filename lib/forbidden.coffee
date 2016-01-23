ForbiddenView = require './forbidden-view'
{CompositeDisposable} = require 'atom'

module.exports = Forbidden =
  config:
    forbiddenWords:
      type: 'string'
      default: 'datum;moist;selfie'

  forbiddenView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @forbiddenView = new ForbiddenView(state.forbiddenViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @forbiddenView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'forbidden:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @forbiddenView.destroy()

  serialize: ->
    forbiddenViewState: @forbiddenView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      words = atom.workspace.getActiveTextEditor().getText().split(/\s+/)
      splitForbiddenWords = atom.config.get('forbidden.forbiddenWords').split(/;/)

      matchingWords = (word for word in words when word in splitForbiddenWords)

      @forbiddenView.setCount(matchingWords.length)
      @modalPanel.show()
