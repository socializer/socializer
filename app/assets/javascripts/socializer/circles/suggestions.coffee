# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@setup = ->
  $(".draggable").draggable
    revert: true
    zIndex: 2500

  $(".droppable").droppable
    hoverClass: "droppable-hover"
    drop: (event, ui) ->
      circle = $("a", @)
      person = ui.draggable
      circle_id = circle.data("object-id")
      person_id = person.data("object-id")
      circle_name = circle.text()
      person_name = person.data("person-name")
      circle_tie_count = $(".circle-tie-count", @)
      $.post("/ties",
        "tie[circle_id]": circle_id
        "tie[contact_id]": person_id
      ).success ->
        tie_count = parseInt(circle_tie_count.html()) + 1
        circle_tie_count.html tie_count.toString()
        return

      return

  return

jQuery ->
  if $("body").data("controller") == "suggestions"
    setup()
