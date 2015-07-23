# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  controller_name = $("body").data("controller")
  if controller_name == "people" || controller_name == "messages"
    messagefrom = "[data-behavior^=message-from-person-]"
    notecontent = $(messagefrom + " [data-behavior~=note-content]")

    notecontent.click().focus()
