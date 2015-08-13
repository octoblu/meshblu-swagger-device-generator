_ = require 'lodash'
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'

class DeviceGenerator
  constructor: (@swaggerFilePath) ->

  toMessageSchema: (callback=->) =>
      swaggerFile = require @swaggerFilePath
      swaggerTransformer = new Swagger2ToMessageSchema swaggerFile
      swaggerTransformer.init (error) =>
        return callback error if error?
        callback null, swaggerTransformer.transform()

module.exports = DeviceGenerator
