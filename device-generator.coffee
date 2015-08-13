_ = require 'lodash'
swagger2 = require('swagger-tools').specs.v2
Swagger2ToMessageSchema = require './swagger-2-to-message-schema'

class DeviceGenerator
  constructor: (@swaggerFilePath) ->
    
  toMessageSchema: (callback) =>    
      swaggerFile = require @swaggerFilePath        
      return callback null, @helloSchema if swaggerFile.swaggerVersion == "1.2"
      swagger2.resolve swaggerFile, (error, result) =>        
        return callback error if error?        
        callback null, properties: subschema: @getActions result
  
  helloSchema: 
    type: 'object'
    properties: 
      subschema: 
        type: 'string'
        enum: [
          'helloSubject'
        ]    
        
  getActionsForV2: (swaggerFile) =>
    actions = []    
    _.each swaggerFile.paths, (path) =>
      _.each path, (pathAction, pathActionName) =>        
        return if pathActionName == 'parameters'
        actions.push pathAction.operationId
        
    actions      
    
    
       
    
    
        
module.exports = DeviceGenerator