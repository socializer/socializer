# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@setup = ->
  $("[data-behavior~=draggable]").draggable
    revert: true
    zIndex: 2500

  $("[data-behavior~=droppable]").droppable
    hoverClass: "droppable-hover"
    drop: (event, ui) ->
      circle = $("a", @)
      person = ui.draggable
      circleId = circle.data("object-id")
      personId = person.data("object-id")
      # TODO: is circle_name needed?
      circle_name = circle.text()
      # TODO: is person_name needed?
      person_name = person.data("person-name")
      circleTieCount = $("[data-behavior~=circle-tie-count]", @)
      $.post("/ties",
        "tie[circle_id]": circleId
        "tie[contact_id]": personId
      ).success ->
        tieCount = parseInt(circleTieCount.html()) + 1
        circleTieCount.html tieCount.toString()
        return

      return

  return

jQuery ->
  if $("body").data("controller") == "suggestions"
    setup()
