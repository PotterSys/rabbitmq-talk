{Distributor, Client} = require "distributor"


# WRTIER (formally the client)
distributor = new Distributor "amqp://localhost:5672", "myExchange", "myApp"
resourceExchange = distributor.register "resource"

resource = 0
makeResource = ->
  resource++
  console.log "trying to make #{resource}"
  resourceExchange.publish {num: resource}

# WORKER (formally the server)
client = new Client distributor.getDefinition()

worker = client.resource.createWorker "resource_queue"

onMessage = (message, cb) ->
  console.log "created resource: #{message.num}"
  cb()

isWorking = true
process.on "SIGINT", ->
  if isWorking then stopWorking() else startWorking()

startWorking = ->
  client.connection.resume()
  isWorking = true

stopWorking = ->
  client.connection.pause()
  isWorking = false

# kick it off
worker.subscribe onMessage
setInterval makeResource, 500
