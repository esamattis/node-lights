

$ ->
  socket =  io.connect "/lights"
  console.log "connecting..."

  socket.on "connect", ->
    console.log "connected!"

  socket.on "light", (data) ->
    console.log "got", data

