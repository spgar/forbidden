ForbiddenView = require './forbidden-view'
{CompositeDisposable} = require 'atom'

module.exports = Forbidden =
  config:
    forbiddenWords:
      type: 'string'
      default: 'datum;moist;selfie'

  forbiddenView: null
  countModalPanel: null
  subscriptions: null

  activate: (state) ->
    @forbiddenView = new ForbiddenView(state.forbiddenViewState)
    @countModalPanel = atom.workspace.addModalPanel(item: @forbiddenView.getCountElement(), visible: false)
    @alertModalPanel = atom.workspace.addModalPanel(item: @forbiddenView.getAlertElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'forbidden:toggle': => @toggle()

    # Monitor saves for all of the text editor
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.getBuffer().onDidSave =>
        @handleOnDidSave()

  deactivate: ->
    @countModalPanel.destroy()
    @subscriptions.dispose()
    @forbiddenView.destroy()

  serialize: ->
    forbiddenViewState: @forbiddenView.serialize()

  getMatchingForbiddenWords: ->
    editorText = atom.workspace.getActiveTextEditor().getText()
    words = editorText.split(/\W+/)
    splitForbiddenWords = atom.config.get('forbidden.forbiddenWords').split(/;/)
    matchingWords = (word for word in words when word in splitForbiddenWords)

  toggle: ->
    if @countModalPanel.isVisible()
      @countModalPanel.hide()
    else
      matchingWords = @getMatchingForbiddenWords()
      @forbiddenView.setCount(matchingWords.length)
      @countModalPanel.show()

  handleOnDidSave: ->
    matchingWordCount = @getMatchingForbiddenWords().length
    if not @alertModalPanel.isVisible() and matchingWordCount > 0
      @forbiddenView.setAlertCount(matchingWordCount)
      @alertModalPanel.show()
