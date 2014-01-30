# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@addTooltipSupport = (jQueryElement) ->
  jQueryElement.qtip
    content:
      text: 'Loading...'
      ajax:
        url: jQueryElement.attr('href')

    style:
      classes: 'qtip-tipsy'

    position:
      my: 'top center'
      at: 'bottom center'
      effect: false

    show:
      event: 'click'
      solo: true

    hide: 'unfocus'

  jQueryElement.click (event) ->
    event.preventDefault()

jQuery ->
  if $('body').data('controller') == 'activities'
    # Add a qTip to all tooltip elements.
    $('.tooltip').each ->
      addTooltipSupport $(this)

  if $('body').data('controller') == 'activities' || controller_name = 'shares'
    # Use moment.js to mimic the Rails time time_ago_in_words helper
    $('time').each ->
      timeago  = $(this).data('time-ago')

      # This could also be timeago?, but this is more explicit
      if timeago is "moment.js"
        datetime = $(this).attr('datetime')
        locale   = $('body').data('locale')

        moment.lang locale

        $(this).text moment(datetime).fromNow()
