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
    console.log 'Forbidden was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
