# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@resetNoteForm = (reset_content = true) ->
  $('#note_content').removeAttr('style')

  if reset_content is true
    $('#note_content').val('')
    $('#note_actions').hide()

  $('#note_object_ids').tokenInput 'clear'

  $('#note_content').on 'click focus', ->
    $('#note_actions').show()
    $(this).animate
      height: 100
    , 'fast'

jQuery ->
  controller_name = $('body').data('controller')
  controller_action = $('body').data('action')
  reset_content = if controller_action is 'edit' then false else true

  if controller_name == 'notes' || controller_name == 'activities' || controller_name == 'people' || controller_name == 'messages'

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

    resetNoteForm(reset_content)

    $('#note_cancel').on 'click', ->
      resetNoteForm(reset_content)
