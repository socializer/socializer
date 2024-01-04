# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: https://coffeescript.org/

jQuery ->
  controllerName = $("body").data("controller")
  if controllerName == "people" || controllerName == "messages"
    messageFrom = "[data-behavior^=message-from-person-]"
    noteContent = $("#{messageFrom} [data-behavior~=note-content]")

    noteContent.click().focus()
