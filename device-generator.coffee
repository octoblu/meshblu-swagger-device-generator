_ = require 'lodash'
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'

class DeviceGenerator
  constructor: (@swaggerFilePath) ->
    
  toMessageSchema: (callback) =>    
      swaggerFile = require @swaggerFilePath        
      return callback null, @helloSchema if swaggerFile.swaggerVersion?
      Swagger2ToMessageSchema.toMessageSchema swaggerFile, callback      
      
  helloSchema: 
    type: 'object'
    properties: 
      subschema: 
        type: 'string'
        enum: [
          'helloSubject'
        ]    
      
module.exports = DeviceGenerator