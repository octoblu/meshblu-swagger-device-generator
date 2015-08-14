swagger2 = require('swagger-tools').specs.v2
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
        @pathIndexByAction[pathAction.operationId] = path
        @actionIndex[pathAction.operationId] = pathAction

  generateMessageSchemas: =>
    _.map @actionIndex, (pathAction, actionName) =>
        @generateMessageSchema actionName, pathAction

  getActions: =>
    _.keys @actionIndex

  generateMessageSchema: (actionName, pathAction) =>
    messageSchema =
      type: "object"
      title: actionName
      description: pathAction.summary
    parameters = _.union pathAction.parameters, @pathIndexByAction[actionName].parameters    
    messageSchema.properties = @getPropertiesFromParameters parameters

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
    _.each parameters,  (parameter) =>
      properties[parameter.name] = @getPropertyFromParameter parameter

    properties

  getPropertyFromParameter: (parameter) =>
    property =
      description: parameter.description
      type: parameter.type

    unless parameter.schema?
      property.required = parameter.required if parameter.required
      return property

    property.type = "object"
    property.properties = @fixSchemaProperties parameter.schema

    property



module.exports = Swagger2ToMessageSchema
