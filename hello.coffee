
dgram = require "dgram"
{jspack} = require "jspack"
express = require "express"

app = express.createServer()

app.get "/", (req, res) ->

  res.send "hello"

class LightReactor

  constructor: (@ip, @port) ->
    @client = dgram.createSocket("udp4")
    @lights = []

  set: (i, r,g,b) ->
    msg = new Buffer(jspack.Pack ">LLBBB", [0,i, r, g, b])
    @client.send msg, 0, msg.length, @port, @ip



if require.main is module
  # l = new LightReactor "85.188.10.47", 9909

  # loop
  #   for i in [0...13]
  #     l.set i, 255, 0, 0
  app.listen 1337
