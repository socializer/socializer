# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: https://coffeescript.org/

jQuery ->
  if $("body").data("controller") == "shares"
    tokeninput = $("[data-behavior~=tokeninput-for-share]")
    audiencePath = tokeninput.data("source")
    prepopulate = null

    tokeninput.tokenInput audiencePath,
      minChars: 0
      preventDuplicates: true
      prePopulate: prepopulate
      resultsFormatter: (item) ->
        "<li><span class='fa fa-fw #{item.icon}'></span> #{item.name}</li>"
