
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
  #
  l = new Lights "127.0.0.1", 1234
  # l = new Lights "85.188.10.47", 1234

  l.set 2, 0, 255, 0
  l.set 20, 0, 255, 0
  setTimeout ->
    l.set 4, 100, 255, 0
    l.set 5, 0, 0, 255
  , 1000
  setTimeout ->
    l.set 7, 100, 0, 255
  , 2000



