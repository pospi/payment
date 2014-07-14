J = (selector) ->
  document.querySelectorAll selector

rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g
J.trim = (text) ->
  if text == null then "" else (text + "").replace rtrim, ""
rreturn = /\r/g
J.val = (el, val) ->
  if arguments.length > 1
    el.value = val
  else
    ret = el.value
    if typeof(ret) == "string"
      ret.replace(rreturn, "")
    else
      if ret == null then "" else ret

J.on = (el, ev, fn) ->
  el.addEventListener ev, fn
  el

J.addClass = (el, className) ->
  return (J.addClass(e, className) for e in el) if el.length

  if (el.classList)
    el.classList.add(className)
  else
    el.className += ' ' + className
J.hasClass = (el, className) ->
  if (el.classList)
    el.classList.contains(className)
  else
    new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className)
J.removeClass = (el, className) ->
  return (J.removeClass(e, className) for e in el) if el.length

  if (el.classList)
    for cls in className.split(' ')
      el.classList.remove(cls)
  else
    el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')
J.toggleClass = (el, className, bool) ->
  return (J.toggleClass(e, className, bool) for e in el) if el.length

  if bool
    J.addClass(el, className) unless J.hasClass(el, className)
  else
    J.removeClass el, className

J.trigger = (el, name, data) ->
  if (window.CustomEvent)
    ev = new CustomEvent(name, {detail: data})
  else
    ev = document.createEvent('CustomEvent')

    # jsdom doesn't have initCustomEvent, so we need this check for
    # testing
    if ev.initCustomEvent
      ev.initCustomEvent name, true, true, data
    else
      ev.initEvent name, true, true, data

  el.dispatchEvent(ev)



module.exports = J