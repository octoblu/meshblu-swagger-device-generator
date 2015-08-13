#!/usr/bin/env coffee

fs = require 'fs'
_  = require 'lodash'
commander = require 'commander'
debug = require('debug')('device-generator:cli')
DeviceGenerator = require './device-generator'

commander
  .version 1.0
  .arguments('[file] swagger file to convert')
  .option '-m, --message-schema [path]', 'Path to the message schema file to output'
  # .option '-f, --form [path]',  'Path to the schema form file to output'
  # .option '-p, --proxy-generator [path]',  'Path to the proxy generator file to output'
  # .option '-a, --all',  'generate all json files related to proxy devices'
  .parse process.argv


commander.help() unless commander.args[0]?

swaggerPath = commander.args[0]

generator = new DeviceGenerator commander.args[0]

if commander.messageSchema?
  messageSchemaPath = commander.messageSchema
  generator.toMessageSchema (error, messageSchema) =>
    return console.error error.message if error?
    fs.writeFileSync messageSchemaPath, JSON.stringify(messageSchema, null, 2)

# channel = JSON.parse fs.readFileSync(commander.infile)

# if commander.jsonSchema?
#   console.log 'generating json schema'
#   channel2Json = new ChannelToJsonSchema()
#   jsonSchema = channel2Json.transform channel
#   fs.writeFileSync(commander.jsonSchema, JSON.stringify(jsonSchema, null, 2))
#
# if commander.form?
#   console.log 'generating form'
#   channel2Form = new ChannelToForm()
#   form = channel2Form.transform channel
#   fs.writeFileSync(commander.form, JSON.stringify(form, null, 2))
#
# if commander.proxyGenerator?
#   console.log 'generating proxy generator file'
#   channel2Proxy = new ChannelToProxyGenerator()
#   proxyGenerator = channel2Proxy.transform channel
#   fs.writeFileSync(commander.proxyGenerator, JSON.stringify(proxyGenerator, null, 2))
