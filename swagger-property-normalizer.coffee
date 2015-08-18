changeCase = require 'change-case'
_ = require 'lodash'

class SwaggerPropertyNormalizer

  constructor: (@swagger={}) ->
    @setupActionIndex()

  setupActionIndex: =>
    @actionIndex = {}
    @pathIndexByAction = {}
    _.each @swagger.paths, (path) =>
      _.each path, (pathAction, pathActionName) =>
        return if pathActionName == 'parameters'
        actionName = @getActionName pathAction.operationId
        @pathIndexByAction[actionName] = path
        @actionIndex[actionName] = pathAction

  getTitle: (title) =>
    changeCase.titleCase title

  getActionName: (actionName) =>
    changeCase.camelCase actionName

  getParameterName: (parameterName) =>
    changeCase.camelCase parameterName

  getBaseUrl: (swagger) =>
    protocol = @getPreferredProtocol swagger.schemes
    "#{protocol}://#{swagger.host}#{swagger.basePath}"

  getPreferredProtocol: (protocols) =>
    return "http" unless protocols?.length > 0
    return "https" if _.contains protocols, "https"
    return protocols[0]

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

  getParametersForAction: (actionName) =>
    actionParameters =
      @findAction(actionName, swagger).properties
    _.union actionParameters, @pathIndexByAction[actionName].parameters

  findAction: (actionName, swagger) =>
    action = {}
    _.each swagger.paths, (path) =>


module.exports = SwaggerPropertyNormalizer
