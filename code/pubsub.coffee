{Distributor, Client} = require "distributor"


# WRTIER
distributor = new Distributor "amqp://localhost:5672", "myExchange", "myApp"
resourceExchange = distributor.register "resource"

resource = 0
makeResource = ->
  resource++
  console.log "trying to make #{resource}"
  resourceExchange.publish {num: resource}

# LISTENERS
client = new Client distributor.getDefinition()

makeListener = (i) ->
  worker = client.resource.createSubscriber()
  worker.subscribe (message, cb) ->
    console.log "hello from #{i} with message #{message.num}"
    cb()



# kick it off
for i in [0..10]
  makeListener i
setInterval makeResource, 500
