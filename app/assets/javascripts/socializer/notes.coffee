# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@resetNoteForm = (reset_content = true) ->
  $("#note_content").removeAttr("style")

  if reset_content == true
    $("#note_content").val("")
    $("#note_actions").hide()

  $("#note_object_ids").tokenInput "clear"

  $("#note_content").on "click focus", ->
    $("#note_actions").show()
    $(this).animate
      height: 100
    , "fast"

jQuery ->
  controller_name = $("body").data("controller")
  controller_action = $("body").data("action")
  reset_content = if controller_action == "edit" then false else true

  if controller_name == "notes" or controller_name == "activities" or
  controller_name == "people" or controller_name == "messages"

    audience_path = $("#note_object_ids").data("source")
    title = $("#note_object_ids").data("title")
    current_id = $("#note_object_ids").data("current-id")
    prepopulate = null

    if current_id != null
      prepopulate = [
        id: current_id
        name: title
      ]

    $("#note_object_ids").tokenInput audience_path,
      minChars: 0
      preventDuplicates: true
      prePopulate: prepopulate
      resultsFormatter: (item) ->
        "<li><span class='fa fa-fw " + item.icon + "'></span> " +
          item.name + "</li>"

    if (current_id != null) and (title == "") or (controller_action == "edit")
      $(".token-input-list").hide()

    resetNoteForm(reset_content)

    $("#note_cancel").on "click", ->
      resetNoteForm(reset_content)
