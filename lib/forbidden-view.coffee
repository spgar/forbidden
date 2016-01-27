module.exports =
class ForbiddenView
  constructor: (serializedState) ->
    # Create count report element
    @countElement = document.createElement('div')
    @countElement.classList.add('forbidden')
    @countElement.appendChild(document.createElement('div'))

    # Create save alert element
    @alertElement = document.createElement('div')
    @alertElement.classList.add('forbiddenAlert')
    @alertElement.appendChild(document.createElement('div'))

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @countElement.remove()
    @alertElement.remove()

  getCountElement: ->
    @countElement

  getAlertElement: ->
    @alertElement

  setCount: (count) ->
    displayText = "There are #{count} forbidden words."
    @countElement.children[0].textContent = displayText

  setAlertCount: (count) ->
    displayText = "You just saved with #{count} forbidden words!"
    @alertElement.children[0].textContent = displayText
