_ = require 'lodash'
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'
MessageSchemaToForm = require './message-schema-to-form'

class DeviceGenerator
  toMessageSchema: (filePath, callback=->) =>
      console.error 'YOU NEED TO CHANGE THE DEVICE EDITOR TO SHOW A SUBSET OF THE SCHEMA FOR REQUIRED, PAYLOAD ISSUES'
      console.error 'DOT CONVERSION FOR GOOGLE'
      console.error 'UNDEFINED TITLE MAPS'
      
      swaggerFile = require filePath
      swaggerTransformer = new Swagger2ToMessageSchema swaggerFile
      swaggerTransformer.init (error) =>
        return callback error if error?
        callback null, swaggerTransformer.transform()

  toForm: (filePath, callback=->) =>
    @toMessageSchema filePath, (error, messageSchema) =>
      return callback error if error?
      messageSchemaTransformer = new MessageSchemaToForm
      form = messageSchemaTransformer.transform messageSchema
      callback null, form

module.exports = DeviceGenerator
