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
  .option '-f, --form [path]',  'Path to the schema form file to output'
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

if commander.form?
  formPath = commander.form
  generator.toForm (error, form) =>
    return console.error error.message if error?
    fs.writeFileSync formPath, JSON.stringify(form, null, 2)
