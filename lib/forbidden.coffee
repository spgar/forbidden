ForbiddenView = require './forbidden-view'
{CompositeDisposable} = require 'atom'

module.exports = Forbidden =
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
      editor = atom.workspace.getActiveTextEditor()
      words = editor.getText().split(/\s+/)

      forbiddenWords = ['datum', 'moist', 'selfie']

      matchingWords = (word for word in words when word in forbiddenWords)

      @forbiddenView.setCount(matchingWords.length)
      @modalPanel.show()
