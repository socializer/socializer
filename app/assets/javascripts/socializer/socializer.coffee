
jQuery ->
  # Replace default titles on images with link by qTip tooltips
  $("[data-behavior~=tooltip-on-hover]").each ->
    $(@).qtip
      content:
        text: $(@).data("content") || true
        title: $(@).data("title") || false
      style:
        classes: "qtip-todc-bootstrap"
        tip: width: 12
      show: solo: true
      position:
        adjust: method: "shift"
        my: "top center"
        at: "bottom center"
        viewport: $(window)
    return
  return
