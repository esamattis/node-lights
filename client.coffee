

jQuery ($) ->

  lights = {}
  $(".light").each ->
    $e = $ this
    lights[parseInt $e.data("light-id")] = $e
  console.log lights

  socket =  io.connect()
  console.log "connecting..."

  socket.on "connect", ->
    console.log "connected!"

  socket.on "light", (data) ->
    [__, id, r, g, b] = data
    id = parseInt id

    console.log JSON.stringify data
    # got [ 0, 5, 0, 255, 0 ] { size: 11, address: '127.0.0.1', port: 34212 }
    lights[id].css "background-color", rgb = "rgb(#{ r }, #{ g },#{ b })"
    lights[id].css "box-shadow", "0px 0px 100px #{ rgb }"


