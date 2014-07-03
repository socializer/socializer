# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $('body').data('controller') == 'shares'
    audience_path = $('#share_object_ids').data('source')
    prepopulate = null

    $('#share_object_ids').tokenInput audience_path,
      minChars: 0
      preventDuplicates: true
      prePopulate: prepopulate
      resultsFormatter: (item) ->
        icon = (if item.name is "Public" then "fa-globe" else "fa-google-circles")
        "<li><span class='fa fa-fw " + icon + "'></span> " + item.name + "</li>"
