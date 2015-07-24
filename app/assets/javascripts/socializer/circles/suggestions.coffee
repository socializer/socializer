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
      circleTieCount = $("[data-behavior~=circle-tie-count]", @)
      $.post("/ties",
        "tie[circle_id]": circle.data("object-id")
        "tie[contact_id]": person.data("object-id")
      ).success ->
        tieCount = parseInt(circleTieCount.html()) + 1
        circleTieCount.html tieCount.toString()
        return

      return

  return

jQuery ->
  if $("body").data("controller") == "suggestions"
    setup()
