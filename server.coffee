
dgram = require "dgram"
{jspack} = require "jspack"
express = require "express"
piler = require "piler"

{Lights} = require "./lightclient"
js = piler.createJSManager()
css = piler.createCSSManager()

config =
  lights: ({id: i} for i in [0...12])
  udpPort: 1234
  webPort: 1337

app = express.createServer()

sockets = io = require("socket.io").listen app

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

io.sockets.on "connection", (socket) ->
  console.log "connection, got web client!!!!"

udbserver.on "message", (packet, rinfo) ->
  msg = jspack.Unpack ">LLBBB", packet, 0
  # got [ 0, 5, 0, 255, 0 ] { size: 11, address: '127.0.0.1', port: 34212 }
  console.log "got", msg, rinfo
  msg.push rinfo.address
  io.sockets.volatile.emit "light", msg,

udbserver.on "listening", ->
  console.log "Listening", udbserver.address()


udbserver.bind config.udpPort
app.listen config.webPort

