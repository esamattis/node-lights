

dgram = require "dgram"

port = 99091

udbserver = dgram.createSocket("udp4")
client = dgram.createSocket("udp4")

udbserver.on "message", (msg, rinfo) ->
  client.send msg, 0, msg.length, 1234, "85.188.10.54"

udbserver.on "listening", ->
  console.log "UDP router is now waiting packets on port #{ port }"

udbserver.bind port

