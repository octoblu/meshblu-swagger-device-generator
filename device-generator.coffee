_ = require 'lodash'
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'

class DeviceGenerator
  constructor: (@swaggerFilePath) ->
    
  toMessageSchema: (callback=->) =>    
      swaggerFile = require @swaggerFilePath        
      return callback null, @helloSchema if swaggerFile.swaggerVersion?
      swaggerTransformer = new Swagger2ToMessageSchema swaggerFile
      swaggerTransformer.init (error) =>
        return callback error if error?
        callback null, swaggerTransformer.transform()
      
  helloSchema: 
    type: 'object'
    properties: 
      subschema: 
        type: 'string'
        enum: [
          'helloSubject'
        ]    
      
module.exports = DeviceGenerator