
dgram = require "dgram"
{jspack} = require "jspack"

Lights = class exports.Lights

  constructor: (@ip, @port) ->
    @client = dgram.createSocket("udp4")
    @lights = []

  set: (i, r,g,b) ->
    msg = new Buffer(jspack.Pack ">LLBBB", [0,i, r, g, b])
    console.log "sending", msg
    @client.send msg, 0, msg.length, @port, @ip

if require.main is module
  # l = new Lights "85.188.10.47", 9909
  l = new Lights "127.0.0.1", 1234

  loop
    for i in [0...13]
      console.log "setting #{ i }"
      l.set i, 0, 255, 0

