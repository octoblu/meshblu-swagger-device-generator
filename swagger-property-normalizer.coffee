changeCase = require 'change-case'
_ = require 'lodash'

class SwaggerPropertyNormalizer

  @getTitle: (title) =>
    changeCase.titleCase title

  @getActionName: (actionName) =>
    changeCase.camelCase actionName

  @getParameterName: (parameterName) =>
    changeCase.camelCase parameterName

  @fixSchemaProperties: (schemaProperties) =>
    fixedSchemaProperties = {}
    schemaProperties = schemaProperties.allOf[0].properties if schemaProperties.allOf?

    _.mapValues schemaProperties, (schemaProperty) =>
      @fixSchemaProperty schemaProperty

  @fixSchemaProperty: (schemaProperty) =>
    fixedSchemaProperty = _.cloneDeep schemaProperty

    if fixedSchemaProperty.items?
      fixedSchemaProperty.items = @fixSchemaProperty fixedSchemaProperty.items
      delete fixedSchemaProperty.required

    if fixedSchemaProperty.properties?
      fixedSchemaProperty.type = 'object' unless fixedSchemaProperty.type?
      fixedSchemaProperty.properties = @fixSchemaProperties schemaProperty.properties
      delete fixedSchemaProperty.required

    fixedSchemaProperty

  @getPropertiesFromParameters: (parameters) =>
    properties = {}
    _.each parameters, (parameter) =>
      parameterName = SwaggerPropertyNormalizer.getParameterName parameter.name
      properties[parameterName] = SwaggerPropertyNormalizer.getPropertyFromParameter parameter

    properties

  @getPropertyFromParameter: (parameter) =>
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
    
module.exports = SwaggerPropertyNormalizer
