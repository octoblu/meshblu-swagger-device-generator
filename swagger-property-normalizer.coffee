changeCase = require 'change-case'
_ = require 'lodash'

class SwaggerPropertyNormalizer

  constructor: (@swagger={}) ->
    @setupIndices()

  setupIndices: =>
    @actionIndex = {}
    @pathConfigByAction = {}
    @pathByAction = {}
    @methodByAction = {}

    _.each @swagger.paths, (pathConfig, path) =>
      _.each pathConfig, (methodConfig, method) =>
        return if method == 'parameters'
        actionName = @getActionName methodConfig.operationId
        @pathByAction[actionName]       = path
        @methodByAction[actionName]     = method.toUpperCase()
        @pathConfigByAction[actionName] = pathConfig
        @actionIndex[actionName]        = methodConfig

  getTitle: (title) =>
    changeCase.titleCase title

  getActionName: (actionName) =>
    changeCase.camelCase actionName

  getParameterName: (parameterName) =>
    changeCase.camelCase parameterName

  getBaseUrl: =>
    protocol = @getPreferredProtocol @swagger.schemes
    "#{protocol}://#{@swagger.host}#{@swagger.basePath}"

  getActions: =>
    _.keys @actionIndex

  getPreferredProtocol: (protocols) =>
    return "http" unless protocols?.length > 0
    return "https" if _.contains protocols, "https"
    return protocols[0]

  fixSchemaProperties: (schemaProperties) =>
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
      property = @getPropertyFromParameter parameter
      return _.extend(properties, property) if parameter.in == 'body'
      properties[parameterName] = @getPropertyFromParameter parameter

    properties

  getPropertyFromParameter: (parameter) =>
    return @fixSchemaProperties parameter.schema if parameter.schema?

    property =
      description: parameter.description
      type: parameter.type
      title: @getTitle parameter.name

    property.required = parameter.required if parameter.required

    property

  getParametersForAction: (actionName) =>
    _.union(
      @pathConfigByAction[actionName].parameters
      @actionIndex[actionName].parameters
    )

  findAction: (actionName, swagger) =>
    action = {}
    _.each swagger.paths, (path) =>


module.exports = SwaggerPropertyNormalizer
