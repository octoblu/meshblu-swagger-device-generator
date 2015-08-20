_ = require 'lodash'
fs = require 'fs'
swagger2 = require('swagger-tools').specs.v2
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'

class DeviceGenerator
  toMessageSchema: (filePath, callback=->) =>
      fs.readFile filePath, 'utf8', (error, swaggerFile) =>
        return callback error if error?
        swagger2.resolve JSON.parse(swaggerFile), (error, swagger) =>
          return callback error if error?
          swaggerTransformer = new Swagger2ToMessageSchema swagger
          callback null, swaggerTransformer.transform()

  toProxyConfig: (filePath, callback=->) =>
      fs.readFile filePath, 'utf8', (error, swaggerFile) =>
        return callback error if error?
        swagger2.resolve JSON.parse(swaggerFile), (error, swagger) =>
          return callback error if error?
          swaggerTransformer = new Swagger2ToMessageSchema swagger
          callback null, swaggerTransformer.transform()

  resolve: (filePath, callback=->) =>
    fs.readFile filePath, 'utf8', (error, swaggerFile) =>
      return callback error if error?
      swagger2.resolve JSON.parse(swaggerFile), callback

module.exports = DeviceGenerator
