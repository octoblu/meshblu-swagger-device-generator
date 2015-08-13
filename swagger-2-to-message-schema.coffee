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

    properties =
      subschema :
        type: 'string'
        enum: actions

    _.each @actionIndex, (pathAction, action) =>
      properties[action] = @getActionProperties pathAction

    type: 'object',
    properties: properties

  getActions: =>
    _.keys @actionIndex

  getActionProperties: (pathAction) =>
    actionProperties = type: "object"

    actionProperties.properties = @getPropertiesFromParameters pathAction.parameters if pathAction.parameters?

    actionProperties

  fixSchemaProperties: (schemaProperties) =>
    fixedSchemaProperties = {}
    schemaProperties = schemaProperties.allOf[0].properties if schemaProperties.allOf?

    _.mapValues schemaProperties, (schemaProperty) =>
      @fixSchemaProperty schemaProperty

  fixSchemaProperty: (schemaProperty) =>
    fixedSchemaProperty = _.cloneDeep schemaProperty

    if fixedSchemaProperty.items?
      console.log 'I HAVE ITEMS!!!', JSON.stringify fixedSchemaProperty, null, 2
      fixedSchemaProperty.items = @fixSchemaProperty fixedSchemaProperty.items

    if fixedSchemaProperty.properties?
      fixedSchemaProperty.type = 'object' unless fixedSchemaProperty.type?
      fixedSchemaProperty.properties = @fixSchemaProperties schemaProperty.properties
      delete fixedSchemaProperty.required

    console.log JSON.stringify fixedSchemaProperty, null, 2
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
