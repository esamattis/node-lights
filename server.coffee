
dgram = require "dgram"
{jspack} = require "jspack"
express = require "express"
piler = require "piler"

{Lights} = require "./lightclient"
js = piler.createJSManager()
css = piler.createCSSManager()

app = express.createServer()
io = require("socket.io").listen app
sockets = io.of "/lights"
app.configure ->
  app.use(express.static(__dirname + '/public'))
  js.bind app
  css.bind app
  css.addFile __dirname + "/style.styl"
  js.addUrl "/socket.io/socket.io.js"
  js.addFile __dirname + "/jquery.js"
  js.addFile __dirname + "/client.coffee"

app.configure "development", ->
  js.liveUpdate css


lights = ({id: i} for i in [1...12])

app.get "/", (req, res) ->

  res.render "index.jade",
    layout: false
    lights: lights


udbserver = dgram.createSocket("udp4")
setInterval ->
  console.log "sending"
  sockets.emit "lights", 123
, 500

sockets.on "connection", (socket) ->
  console.log "got web client!!!!"

udbserver.on "message", (packet, rinfo) ->
  msg = jspack.Unpack ">LLBBB", packet, 0
  # got [ 0, 5, 0, 255, 0 ] { size: 11, address: '127.0.0.1', port: 34212 }
  console.log "got", msg, rinfo
  sockets.broadcast.emit "lights", msg

udbserver.on "listening", ->
  console.log "Listening", udbserver.address()

udbserver.bind 1234

app.listen 1337

