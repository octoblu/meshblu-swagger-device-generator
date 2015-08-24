#!/usr/bin/env coffee

fs = require 'fs'
_  = require 'lodash'
commander = require 'commander'
debug = require('debug')('swagger-transformer:cli')
SwaggerTransformer = require './parser/swagger-transformer'

commander
  .version 1.0
  .arguments('[file] swagger file to convert')
  .option '-m, --message-schema [path]', 'Path to the message schema file to output'
  .option '-p, --proxy-generator-config [path]',  'Path to the proxy generator config file to output'
  .option '-r, --resolve [path]',  'Path to the resolved swagger file to output'
  .parse process.argv


commander.help() unless commander.args[0]?

swaggerPath = commander.args[0]

generator = new SwaggerTransformer

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
