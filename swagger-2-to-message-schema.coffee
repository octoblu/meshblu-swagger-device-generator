_ = require 'lodash'
SwaggerPropertyNormalizer = require './swagger-property-normalizer'
class Swagger2ToMessageSchema
  constructor: (@swagger={}) ->
    @setupActionIndex()

  transform: =>
    @generateMessageSchemas()

  setupActionIndex: =>
    @actionIndex = {}
    @pathIndexByAction = {}
    _.each @swagger.paths, (path) =>
      _.each path, (pathAction, pathActionName) =>
        return if pathActionName == 'parameters'
        actionName = SwaggerPropertyNormalizer.getActionName pathAction.operationId
        @pathIndexByAction[actionName] = path
        @actionIndex[actionName] = pathAction

  generateMessageSchemas: =>
    messageSchemas =
      title: SwaggerPropertyNormalizer.getTitle @swagger?.info?.title || 'root'
    _.each @actionIndex, (pathAction, actionName) =>
        messageSchemas[actionName] = @generateMessageSchema actionName, pathAction

    messageSchemas

  generateMessageSchema: (actionName, pathAction) =>
    messageSchema =
      $schema: "http://json-schema.org/draft-04/schema#"
      type: "object"
      title: SwaggerPropertyNormalizer.getTitle actionName
      description: pathAction.summary
      additionalProperties: false
      properties:
        action:
          type: "hidden"
          default: actionName
        options:
          additionalProperties: false
          title: SwaggerPropertyNormalizer.getTitle actionName
          type: "object"
          properties: []

    parameters = _.union pathAction.parameters, @pathIndexByAction[actionName].parameters
    messageSchema.properties.options.properties = @getPropertiesFromParameters parameters

    messageSchema

  getPropertiesFromParameters: (parameters) =>
    properties = {}
    _.each parameters, (parameter) =>
      parameterName = SwaggerPropertyNormalizer.getParameterName parameter.name
      properties[parameterName] = @getPropertyFromParameter parameter

    properties

  getPropertyFromParameter: (parameter) =>
    property =
      description: parameter.description
      type: parameter.type
      title: SwaggerPropertyNormalizer.getTitle parameter.name

    unless parameter.schema?
      property.required = parameter.required if parameter.required
      return property

    property.type = "object"
    property.properties = SwaggerPropertyNormalizer.fixSchemaProperties parameter.schema

    property



module.exports = Swagger2ToMessageSchema
