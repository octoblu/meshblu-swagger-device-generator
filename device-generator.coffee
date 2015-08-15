_ = require 'lodash'
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'
MessageSchemaToForm = require './message-schema-to-form'
ProxyConfigToClass = require './proxy-config-to-class'

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
  
  toClass: (filePath, callback=->) =>        
    @toMessageSchema filePath, (error, messageSchema) =>
      return callback error if error?      
      classTransformer = new ProxyConfigToClass messageSchema
      theClass = classTransformer.transform()
      callback null, theClass
  

module.exports = DeviceGenerator
