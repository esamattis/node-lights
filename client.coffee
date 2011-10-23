
$ ->
  $("span.server").text " #{ location.hostname }:#{ config.udpPort } "

class Log

  constructor: (@opts) ->
    @el = @opts.el
    @messages = []
    @dirty = false

    setInterval =>
      @render() if @dirty
    , 20


  log: (msg) ->
    @messages.unshift msg

    if @messages.length > 100
      @messages.pop()

    @dirty = true

  render: ->
    html = ""
    for msg in @messages
      html += "<p>#{ msg }</p>" 
    @el.innerHTML = html
    console.log html
    @dirty = false




jQuery ($) ->
  window.err = new Log el: $(".log .err").get 0
  window.info = new Log el: $(".log .info").get 0

  lights = {}
  $(".light").each ->
    $e = $ this
    lights[parseInt $e.data("light-id")] = $e
  console.log lights

  socket =  io.connect()
  console.log "connecting..."

  socket.on "connect", ->
    console.log "connected!"

  socket.on "packeterror", (data) ->
      err.log "#{ data.ip } sent #{ data.packet }"

  socket.on "light", (data) ->
    [__, id, r, g, b, ip] = data
    light = lights[id = parseInt id]

    if not light
      err.log "#{ ip } Tried setting non-existent id #{ id }"
      return

    light.css "background-color", rgb = "rgb(#{ r }, #{ g },#{ b })"
    light.css "box-shadow", "0px 0px 100px #{ rgb }"
    info.log "#{ ip } set #{ id } to #{ rgb }"


