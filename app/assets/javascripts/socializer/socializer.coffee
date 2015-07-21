
jQuery ->
  # Replace default titles on images with link by qTip tooltips
  $('a [title!=""], a[title!=""], [data-content!=""], [data-title!=""]').each ->
    $(this).qtip
      content:
        text: $(this).data('content') or true
        title: $(this).data('title') or false
      style:
        classes: 'qtip-todc-bootstrap'
        tip: width: 12
      show: solo: true
      position:
        adjust: method: 'shift'
        my: 'top center'
        at: 'bottom center'
        viewport: $(window)
    return
  return
