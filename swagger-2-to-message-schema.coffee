swagger2 = require('swagger-tools').specs.v2
_ = require 'lodash'
class Swagger2ToMessageSchema
  constructor: (@swaggerFile) ->
  
  init: (callback=->) =>
    swagger2.resolve @swaggerFile, (error, @swagger) =>
      @setupActionIndex()
      callback error, null        
  
  transform: =>    
    @generateMessageSchema()
  
  setupActionIndex: =>
    @actionIndex = {}
    _.each @swagger.paths, (path) =>
      _.each path, (pathAction, pathActionName) =>        
        return if pathActionName == 'parameters'
        @actionIndex[pathAction.operationId] = pathAction        
  
  generateMessageSchema: =>
    actions = @getActions()
    properties = {}
    _.each @actionIndex, (pathAction, action) =>
      properties[action] = @getPropertiesFromPath pathAction
                
    messageSchema =
      type: 'object',
      properties:
        subschema:
          type: 'string'
          enum: actions              
  
  getActions: =>
    _.keys @actionIndex
  
  getPropertiesFromPath: (pathAction) =>              
    # console.log 'pathAction', pathAction     
    properties = {}
    _.each pathAction.parameters, (parameter) =>      
      properties[parameter.name] = @getPropertiesFromParameter parameter
    
    console.log 'properties', properties
    properties
  
  getPropertiesFromParameter: (parameter) =>
    console.log 'parameter', parameter
    required: parameter.required if parameter.required
    description: parameter.description
    type: parameter.type

    

module.exports = Swagger2ToMessageSchema