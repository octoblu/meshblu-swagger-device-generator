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
module.exports = SwaggerPropertyNormalizer
