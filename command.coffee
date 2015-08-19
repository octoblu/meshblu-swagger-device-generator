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
  .option '-p, --proxy-generator-config [path]',  'Path to the proxy generator config file to output'
  .option '-r, --resolve [path]',  'Path to the resolved swagger file to output'
  # .option '-p, --proxy-generator [path]',  'Path to the proxy generator file to output'
  # .option '-a, --all',  'generate all json files related to proxy devices'
  .parse process.argv


commander.help() unless commander.args[0]?

swaggerPath = commander.args[0]

generator = new DeviceGenerator

if commander.messageSchema?
  messageSchemaPath = commander.messageSchema
  generator.toMessageSchema swaggerPath, (error, messageSchema) =>
    return console.error error.message if error?
    fs.writeFileSync messageSchemaPath, JSON.stringify(messageSchema, null, 2)

if commander.proxyGeneratorConfig?
  path = commander.proxyGeneratorConfig
  generator.toProxyConfig swaggerPath, (error, proxyConfig) =>
    return console.error error.message if error?
    fs.writeFileSync path, JSON.stringify(proxyConfig, null, 2)

if commander.resolve?
  resolvePath = commander.resolve
  generator.resolve swaggerPath, (error, resolve) =>
    return console.error error.message if error?
    fs.writeFileSync resolvePath, JSON.stringify(resolve, null, 2)
