swagger2 = require('swagger-tools').specs.v2
changeCase = require 'change-case'
_ = require 'lodash'
class Swagger2ToMessageSchema
  constructor: (@swaggerFile) ->

  init: (callback=->) =>
    swagger2.resolve @swaggerFile, (error, @swagger) =>
      @setupActionIndex()
      callback error, null

  transform: =>
    @generateMessageSchemas()

  setupActionIndex: =>
    @actionIndex = {}
    @pathIndexByAction = {}
    _.each @swagger.paths, (path) =>
      _.each path, (pathAction, pathActionName) =>
        return if pathActionName == 'parameters'
        actionName = @getActionName pathAction.operationId
        @pathIndexByAction[actionName] = path
        @actionIndex[actionName] = pathAction

  generateMessageSchemas: =>
    messageSchemas = title: @getTitle @swagger?.info?.title || 'root'
    _.each @actionIndex, (pathAction, actionName) =>
        messageSchemas[actionName] = @generateMessageSchema actionName, pathAction
        
    messageSchemas

  getTitle: (title) =>
    changeCase.titleCase title
  
  getActionName: (actionName) =>
    changeCase.camelCase actionName
  
  getParameterName: (parameterName) =>
    changeCase.camelCase parameterName
    
  getActions: =>
    _.keys @actionIndex

  generateMessageSchema: (actionName, pathAction) =>
    messageSchema =      
      type: "object"
      title: @getTitle actionName
      description: pathAction.summary
      additionalProperties: false
      properties:
        action:
          type: "hidden"
          default: actionName
        options:          
          additionalProperties: false
          title: @getTitle actionName
          type: "object"
          properties: []

    parameters = _.union pathAction.parameters, @pathIndexByAction[actionName].parameters
    messageSchema.properties.options.properties = @getPropertiesFromParameters parameters

    messageSchema

  fixSchemaProperties: (schemaProperties) =>
    fixedSchemaProperties = {}
    schemaProperties = schemaProperties.allOf[0].properties if schemaProperties.allOf?

    _.mapValues schemaProperties, (schemaProperty) =>
      @fixSchemaProperty schemaProperty

  fixSchemaProperty: (schemaProperty) =>
    fixedSchemaProperty = _.cloneDeep schemaProperty

    if fixedSchemaProperty.items?
      fixedSchemaProperty.items = @fixSchemaProperty fixedSchemaProperty.items
      delete fixedSchemaProperty.required

    if fixedSchemaProperty.properties?
      fixedSchemaProperty.type = 'object' unless fixedSchemaProperty.type?
      fixedSchemaProperty.properties = @fixSchemaProperties schemaProperty.properties
      delete fixedSchemaProperty.required

    fixedSchemaProperty

  getPropertiesFromParameters: (parameters) =>
    properties = {}
    _.each parameters, (parameter) =>
      parameterName = @getParameterName parameter.name
      properties[parameterName] = @getPropertyFromParameter parameter

    properties

  getPropertyFromParameter: (parameter) =>
    property =
      description: parameter.description
      type: parameter.type
      title: @getTitle parameter.name

    unless parameter.schema?
      property.required = parameter.required if parameter.required
      return property

    property.type = "object"
    property.properties = @fixSchemaProperties parameter.schema

    property



module.exports = Swagger2ToMessageSchema
