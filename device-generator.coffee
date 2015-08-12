When      = require 'when'
WhenNode  = require 'when/node'
swagger1 = require('swagger-tools').specs.v1
class DeviceGenerator
  constructor: (@swaggerFilePath) ->
    
  toMessageSchema: =>
    swaggerFile = require @swaggerFilePath        
    return @helloSchema if swaggerFile.swaggerVersion == "1.2"
    swagger1.resolve swaggerFile, (err, result)=>
      console.log err, result
  
  helloSchema: 
    type: 'object'
    properties: 
      subschema: 
        type: 'string'
        enum: [
          'helloSubject'
        ]    
        
  parseSwaggerFile: =>
    
    
       
    
    
        
module.exports = DeviceGenerator