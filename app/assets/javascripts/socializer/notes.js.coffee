# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@resetNoteForm = ->
  $('#note_content').removeAttr('style').val('')
  $('#note_object_ids').hide()
  $('.token-input-list').hide()
  $('#new_note .action-button').hide()

  $('#note_content').one 'click', ->
    $(this).animate
      height: 100
    , 'fast'

    audience_path = $('#note_object_ids').data('source')
    title = $('#note_object_ids').data('title')
    current_id = $('#note_object_ids').data('current-id')
    prepopulate = null

    if current_id?
      prepopulate = [
        id: current_id
        name: title
      ]

    $('#note_object_ids').tokenInput audience_path,
      minChars: 0
      preventDuplicates: true
      prePopulate: prepopulate
      resultsFormatter: (item) ->
        "<li><span class='fa fa-fw " + item.icon + "'></span> " + item.name + "</li>"

    $('.token-input-list').hide()  if (current_id?) and (title is '')
    $('#new_note .action-button').show()

jQuery ->
  controller_name = $('body').data('controller')
  if controller_name == 'notes' || controller_name = 'activities'
    resetNoteForm()
