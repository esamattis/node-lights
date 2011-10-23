

dgram = require "dgram"

port = 9909

udbserver = dgram.createSocket("udp4")
client = dgram.createSocket("udp4")

udbserver.on "message", (msg, rinfo) ->
  # client.send msg, 0, msg.length, 1234, "127.0.0.1"
  client.send msg, 0, msg.length, 9910, "127.0.0.1"

udbserver.on "listening", ->
  console.log "UDP router is now waiting packets on port #{ port }"

udbserver.bind port

