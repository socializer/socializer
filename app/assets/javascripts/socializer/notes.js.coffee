# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@resetNoteForm = (controller_action) ->
  $('#note_content').removeAttr('style')
  $('#note_content').val('') if controller_action == 'index'
  $('#note_object_ids').hide()
  $('.token-input-list').hide()
  $('#new_note .action-button').hide()

  $('#note_content').one 'click focus', ->
    $(this).animate
      height: 100
    , 'fast'

    audience_path = $('#note_object_ids').data('source')
    title = $('#note_object_ids').data('title')
    current_id = $('#note_object_ids').data('current-id')
    prepopulate = null

    if current_id isnt null
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

    $('.token-input-list').hide()  if (current_id isnt null) and (title is '') or (controller_action == 'edit')
    $('#new_note .action-button').show()

jQuery ->
  controller_name = $('body').data('controller')
  controller_action = $('body').data('action')
  if controller_name == 'notes' || controller_name == 'activities' || controller_name == 'people'
    resetNoteForm(controller_action)
