# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  controller_name = $('body').data('controller')
  if controller_name == 'people' or controller_name == 'messages'
    $('[id^=message_person_] #note_content').click().focus()
