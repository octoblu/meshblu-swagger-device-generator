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
    throw new Error "Form isn't supported for now. It may not be needed."
    @toMessageSchema filePath, (error, messageSchema) =>
      return callback error if error?
      messageSchemaTransformer = new MessageSchemaToForm
      form = messageSchemaTransformer.transform messageSchema
      callback null, form

module.exports = DeviceGenerator
