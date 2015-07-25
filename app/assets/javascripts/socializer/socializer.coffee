
jQuery ->
  $("[data-behavior~=tooltip-on-hover]").each ->
    $(@).qtip
      content:
        text: $(@).data("content") || true
        title: (event, api) ->
          title = $(@).data("title")
          return api.set("content.title", false) if typeof title == "undefined"
          return title
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
