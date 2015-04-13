# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $('body').data('controller') == 'people'
    $('[id^=message_person_] #note_content').click().focus()
