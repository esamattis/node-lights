
dgram = require "dgram"
{jspack} = require "jspack"
express = require "express"
piler = require "piler"

{Lights} = require "./lightclient"
js = piler.createJSManager()
css = piler.createCSSManager()

config =
  lights: ({id: i} for i in [0...13])
  udpPort: 1234
  webPort: 1337

app = express.createServer()

sockets = io = require("socket.io").listen app
io.set "log level", 0

app.configure ->
  app.use(express.static(__dirname + '/public'))
  js.bind app
  css.bind app
  css.addFile __dirname + "/style.styl"
  js.addUrl "/socket.io/socket.io.js"
  js.addFile __dirname + "/jquery.js"
  js.addFile __dirname + "/client.coffee"
  js.addOb config: config

app.configure "development", ->
  js.liveUpdate css, io


app.get "/", (req, res) ->

  res.render "index.jade",
    layout: false
    config: config


udbserver = dgram.createSocket("udp4")

udbserver.on "message", (packet, rinfo) ->
  pos = 0
  while pos < packet.length

    msg = jspack.Unpack ">LLBBB", packet.slice(pos, pos+11), 0
    pos += 11

    if msg
      console.log "sending", msg
      msg.push rinfo.address
      # io.sockets.emit "light", msg
      io.sockets.volatile.emit "light", msg
    else
      console.log "bad packet #{ packet } from rinfo.address"
      io.sockets.volatile.emit "packeterror",
        packet: packets.toString()
        ip: rinfo.address

udbserver.on "listening", ->
  console.log "UDP server is now waiting packets on port #{ config.udpPort }"

app.on "listening", ->
  console.log "View simulator on http://(TODO:configureme):#{ config.webPort }/"


udbserver.bind config.udpPort
app.listen config.webPort
