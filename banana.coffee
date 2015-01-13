ping = require("net-ping")
yaml = require("js-yaml")
fs = require("fs")
chalk = require("chalk")
chalkError = chalk.bold.red
chalkLine = chalk.dim.yellow
chalkOk = chalk.bold.green
chalkDebug = chalk.dim.gray
logFile = "logs/debug.log"

pingEndpoints = (callback) ->
  results = []
  completed = 0
  totalTargets = config.endpoints.network.length + 
    config.endpoints.servers.length
  Object.keys(config.endpoints).forEach (type) ->
    config.endpoints[type].forEach (endpoint) ->
      session.pingHost endpoint.target, (error, target, sent, rcvd) ->
        ms = rcvd - sent
        result =
          target: target
          rtt: ms
          error: error
          description: endpoint.description

        results.push result
        if DEBUG
          fs.appendFile logFile, JSON.stringify(result) + '\n', (err) ->
            console.error err if err
            return
        callback results  if ++completed is totalTargets
        return
      return
    return
  
  callback results
  return

feed = (error, target, ttl, sent, rcvd) ->
  ms = rcvd - sent
  err = ""
  if error and error instanceof ping.TimeExceededError
    err = error.source
  else
    err = error.toString()
  traceroute[target].push
    target: target
    error: err
    ttl: ttl
    ms: ms

  return
done = (error, target) ->
  console.log()
  console.error chalkOk("Traceroute results for #{target}.")
  console.error chalkLine("--------------------------------------")
  traceroute[target].forEach (t) ->
    console.error chalkError("#{t.target}: #{t.error}. " +
      "ttl=#{t.ttl}. ms=#{t.ms}.")
    return

  console.log()
  return

configFile = process.env.BANANA_CONF or __dirname + "/config/config.yml"
DEBUG = process.env.BANANA_DEBUG or null

try
  config = yaml.safeLoad(fs.readFileSync(configFile, "utf8"))
catch e
  console.error chalkError("Failed to load config file: " + e)

session = ping.createSession(packetSize: config.size)
traceroute = {}

pingEndpoints (results) ->
  completed = 0
  errors = false
  results.forEach (result) ->
    if result.error
      console.error chalkError("Failed to reach #{result.target} " +
        "(#{result.description}). Beginning traceroute.")
      traceroute[result.target] = []
      session.traceRoute result.target, 30, feed, done
      errors = true

    unless errors
      if ++completed is results.length
        console.log chalkOk("Congratulations!  All endpoints are reachable.")
  return
return
