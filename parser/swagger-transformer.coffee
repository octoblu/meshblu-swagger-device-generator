_ = require 'lodash'
fs = require 'fs'
path = require 'path'
swagger2 = require('swagger-tools').specs.v2
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'
Swagger2ToProxyConfig = require './swagger-2-to-proxy-config'

class SwaggerTransformer
  toMessageSchema: (filePath, callback=->) =>
    fs.readFile path.resolve(filePath), 'utf8', (error, swaggerFile) =>
      return callback error if error?
      swagger2.resolve JSON.parse(swaggerFile), (error, swagger) =>
        return callback error if error?
        swaggerTransformer = new Swagger2ToMessageSchema swagger
        callback null, swaggerTransformer.transform()

  toProxyConfig: (filePath, callback=->) =>
    fs.readFile path.resolve(filePath), 'utf8', (error, swaggerFile) =>
      return callback error if error?
      swagger2.resolve JSON.parse(swaggerFile), (error, swagger) =>
        return callback error if error?
        swaggerTransformer = new Swagger2ToProxyConfig swagger
        callback null, swaggerTransformer.transform()

  resolve: (filePath, callback=->) =>
    fs.readFile filePath, 'utf8', (error, swaggerFile) =>
      return callback error if error?
      swagger2.resolve JSON.parse(swaggerFile), callback

module.exports = SwaggerTransformer
