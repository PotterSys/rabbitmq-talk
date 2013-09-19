express = require "express"
http = require "http"
request = require "request"
PORT = 1234

# SERVER
app = express()
isListening = false
app.use express.json()
app.post "/resource", (req, res) ->
  console.log "created resource: #{req.body.num}"
  res.send()

server = http.createServer(app)

listen = (cb) ->
  server.listen PORT, ->
    isListening = true
    cb() if cb

stop = ->
  server.close -> isListening = false

process.on "SIGINT", -> if isListening then stop() else listen()

# CLIENT
resource = 0
makeResource = ->
  resource++
  console.log "trying to make #{resource}"
  request.post {url: "http://localhost:#{PORT}/resource", body: {num: resource}, timeout: 1000, json: true}, (err, resp) ->
    if !err and resp and resp.statusCode == 200
      console.log "SUCCESS ON #{resource}"
    else
      console.log "FAILED ON #{resource}"

# kick it off
listen ->
  setInterval makeResource, 500
