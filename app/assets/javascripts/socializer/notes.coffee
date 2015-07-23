# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@resetNoteForm = (reset_content = true) ->
  notecontent = $("[data-behavior~=note-content]")

  notecontent.removeAttr("style")

  if reset_content == true
    notecontent.val("")
    $("#note_actions").hide()

  tokeninput = $("[data-behavior~=tokeninput-for-note]")
  tokeninput.tokenInput "clear"

  notecontent.on "click focus", ->
    $("#note_actions").show()
    $(@).animate
      height: 100
    , "fast"

jQuery ->
  controller_name = $("body").data("controller")
  controller_action = $("body").data("action")
  reset_content = if controller_action == "edit" then false else true

  if controller_name == "notes" || controller_name == "activities" ||
  controller_name == "people" || controller_name == "messages"

    tokeninput = $("[data-behavior~=tokeninput-for-note]")
    audience_path = tokeninput.data("source")
    title = tokeninput.data("title")
    current_id = tokeninput.data("current-id")
    prepopulate = null

    if current_id != null
      prepopulate = [
        id: current_id
        name: title
      ]

    tokeninput.tokenInput audience_path,
      minChars: 0
      preventDuplicates: true
      prePopulate: prepopulate
      resultsFormatter: (item) ->
        "<li><span class='fa fa-fw " + item.icon + "'></span> " +
          item.name + "</li>"

    if (current_id != null) && (title == "") || (controller_action == "edit")
      $(".token-input-list").hide()

    resetNoteForm(reset_content)

    $("[data-behavior~=cancel-note-form]").on "click", ->
      resetNoteForm(reset_content)
