# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: https://coffeescript.org/

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
      behavior = "[data-behavior~=circle-tie-count-#{circleId}]"
      circleTieCount = $(behavior, @)
      $.post("/ties",
        "tie[circle_id]": circleId
        "tie[contact_id]": person.data("object-id")
      ).success ->
        tieCount = parseInt(circleTieCount.html()) + 1
        circleTieCount.html tieCount.toString()
        # NOTE: May want to add a data attribure to the view that supplies
        #       the pluralized/localized value
        #       data-pluralized-person
        personOrPeople = if tieCount > 1 then "people" else "person"
        circle.data("title", "#{tieCount} #{personOrPeople} in this circler")
        return

      return

  return

jQuery ->
  if $("body").data("controller") == "suggestions"
    setup()
