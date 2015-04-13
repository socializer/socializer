# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@addTimeAgoSupport = ->
  # Use moment.js to mimic Google+
  $('time').each ->
    timeago  = $(this).data('time-ago')

    # This could also be timeago?, but this is more explicit
    if timeago is 'moment.js'
      locale   = $('body').data('locale')
      moment.locale locale

      datetime = moment($(this).attr('datetime'))

      $(this).text distance_of_time(datetime)

distance_of_time = (past_date) ->
  past_date ?= 0
  today = moment()
  days_difference = today.diff(past_date, 'days')

  moment.locale 'en',
    calendar:
      sameDay: "LT"
      nextDay: '[Tomorrow] LT'
      nextWeek: 'll'
      lastDay: '[Yesterday] LT'
      lastWeek: 'll'
      sameElse: 'll'

  moment.locale 'fr',
    calendar:
      sameDay: "LT"
      nextDay: '[Demain] LT'
      nextWeek: 'll'
      lastDay: '[Hier] LT'
      lastWeek: 'll'
      sameElse: 'll'

  moment(past_date).calendar()


@addTooltipSupport = (jQueryElement) ->
  jQueryElement.qtip
    content:
      text: 'Loading...'
      ajax:
        url: jQueryElement.attr('href')

    style:
      classes: 'qtip-todc-bootstrap'
      tip:
        width: 12

    position:
      my: 'top center'
      at: 'bottom center'
      effect: false
      viewport: $(window)

    show:
      event: 'click'
      solo: true

    hide: 'unfocus'

  jQueryElement.click (event) ->
    event.preventDefault()

jQuery ->
  controller_name = $('body').data('controller')
  if controller_name == 'activities'
    # Add a qTip to all tooltip elements.
    $('.tooltip').each ->
      addTooltipSupport $(this)

  if controller_name == 'activities' || controller_name = 'shares'
    addTimeAgoSupport()
