swagger2 = require('swagger-tools').specs.v2
_ = require 'lodash'
class Swagger2ToMessageSchema
  @toMessageSchema: (swagger, callback) =>
    swagger2.resolve swagger, (error, result) =>        
      return callback error if error?        
      callback null, @generateMessageSchema swagger
  
  @generateMessageSchema: (swagger) =>
    messageSchema =
      type: 'object',
      properties:
        subschema:
          type: 'string'
          enum: @getActions swagger
  
  @getActions: (swagger) =>
    actions = []    
    _.each swagger.paths, (path) =>
      _.each path, (pathAction, pathActionName) =>        
        return if pathActionName == 'parameters'
        actions.push pathAction.operationId
        
    actions 

module.exports = Swagger2ToMessageSchema