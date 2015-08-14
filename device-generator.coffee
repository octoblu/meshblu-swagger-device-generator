_ = require 'lodash'
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'
MessageSchemaToForm = require './message-schema-to-form'

class DeviceGenerator
  toMessageSchema: (filePath, callback=->) =>
      swaggerFile = require filePath
      swaggerTransformer = new Swagger2ToMessageSchema swaggerFile
      swaggerTransformer.init (error) =>
        return callback error if error?
        callback null, swaggerTransformer.transform()

  toForm: (filePath, callback=->) =>
      messageSchemaFile = require filePath
      messageSchemaTransformer = new MessageSchemaToForm
      _.defer => callback null, messageSchemaTransformer.transform messageSchemaFile

module.exports = DeviceGenerator
