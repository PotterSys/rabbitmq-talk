{Distributor, Client} = require "distributor"


distributor = new Distributor "amqp://localhost:5672", "myApp", "myApp"
logger = distributor.register "logs"
levels = ["warn", "info", "debug"]
for level in levels
  logger.registerSubTopic level

logger.registerSubTopic "error"

process.on "SIGINT", ->
  logger.publishError {message: "OH NO!!!"}

count = 0
makeLog = ->
  toLog = ++count % levels.length
  if toLog == 0
    logger.publishDebug {message: "hurp durp"}
  else if toLog == 1
    logger.publishInfo {message: "GET /yourmom 413 (lolz)"}
  else if toLog == 2
    logger.publishWarn {message: "I a word"}


# log receiver
client = new Client distributor.getDefinition()

boringLogWorker = client.logs.createWorker "boring_logs"
excitingLogWorker = client.logs.createWorker "exciting_logs"

boringMessage = (msg, cb) ->
  console.log "no one ever cares about me...", msg.message
  cb()

# since we don't have a namespace to define it, we have to enumerate what we want
for level in levels
  boringLogWorker.subscribe "myApp.logs.#{level}", boringMessage

excitingMessage = (msg, cb) ->
  console.log "EMAIL EVERYONE!!!!, FIRE ALERT", msg.message
  cb()

excitingLogWorker.subscribe "myApp.logs.error", excitingMessage

# kick it off
setInterval makeLog, 500
