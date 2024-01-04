# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: https://coffeescript.org/

@addTimeAgoSupport = ->
  # Use moment.js to mimic Google+
  $("time").each ->
    timeago  = $(@).data("time-ago")

    # This could also be timeago?, but this is more explicit
    if timeago == "moment.js"
      locale   = $("body").data("locale")
      moment.locale locale

      datetime = moment($(@).attr("datetime"))

      $(@).text distanceOfTime(datetime)

distanceOfTime = (pastDate) ->
  pastDate ?= 0
  today = moment()

  moment.locale "en",
    calendar:
      sameDay: "LT"
      nextDay: "[Tomorrow] LT"
      nextWeek: "ll"
      lastDay: "[Yesterday] LT"
      lastWeek: "ll"
      sameElse: "ll"

  moment.locale "fr",
    calendar:
      sameDay: "LT"
      nextDay: "[Demain] LT"
      nextWeek: "ll"
      lastDay: "[Hier] LT"
      lastWeek: "ll"
      sameElse: "ll"

  moment(pastDate).calendar()


@addTooltipSupport = (jQueryElement) ->
  jQueryElement.qtip
    content:
      text: "Loading..."
      ajax:
        url: jQueryElement.attr("href")

    style:
      classes: "qtip-todc-bootstrap"
      tip:
        width: 12

    position:
      my: "top center"
      at: "bottom center"
      effect: false
      viewport: $(window)

    show:
      event: "click"
      solo: true

    hide: "unfocus"

  jQueryElement.click (event) ->
    event.preventDefault()

jQuery ->
  controllerName = $("body").data("controller")
  if controllerName == "activities"
    $("[data-behavior~=tooltip-on-click]").each ->
      addTooltipSupport $(@)

  if controllerName == "activities" || controllerName == "shares"
    addTimeAgoSupport()
