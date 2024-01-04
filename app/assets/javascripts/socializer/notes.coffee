# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: https://coffeescript.org/

@resetNoteForm = (resetContent = true) ->
  noteContent = $("[data-behavior~=note-content]")
  noteActions = $("[data-behavior~=note-actions]")

  noteContent.removeAttr("style")

  if resetContent == true
    noteContent.val("")
    noteActions.hide()

  tokeninput = $("[data-behavior~=tokeninput-for-note]")
  tokeninput.tokenInput "clear"

  noteContent.on "click focus", ->
    noteActions.show()
    $(@).animate
      height: 100
    , "fast"

@setup = (controllerName, controllerAction) ->
  resetContent = if controllerAction == "edit" then false else true
  tokeninput = $("[data-behavior~=tokeninput-for-note]")
  audiencePath = tokeninput.data("source")
  title = tokeninput.data("title")
  currentId = tokeninput.data("current-id")
  prepopulate = null

  if currentId != null
    prepopulate = [
      id: currentId
      name: title
    ]

  tokeninput.tokenInput audiencePath,
    minChars: 0
    preventDuplicates: true
    prePopulate: prepopulate
    resultsFormatter: (item) ->
      "<li><span class='fa fa-fw #{item.icon}'></span> #{item.name}</li>"

  if (currentId != null) && (title == "") || (controllerAction == "edit")
    $(".token-input-list").hide()

  resetNoteForm(resetContent)

  $("[data-behavior~=cancel-note-form]").on "click", ->
    resetNoteForm(resetContent)

jQuery ->
  controllerName = $("body").data("controller")
  controllerAction = $("body").data("action")

  if controllerName == "notes" || controllerName == "activities" ||
  controllerName == "people" || controllerName == "messages"

    setup(controllerName, controllerAction)
