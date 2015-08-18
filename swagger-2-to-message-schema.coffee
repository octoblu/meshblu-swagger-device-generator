_ = require 'lodash'
SwaggerPropertyNormalizer = require './swagger-property-normalizer'
class Swagger2ToMessageSchema extends SwaggerPropertyNormalizer
  
  transform: =>
    @generateMessageSchemas()

  generateMessageSchemas: =>
    messageSchemas =
      title: @getTitle @swagger?.info?.title || 'root'
    _.each @actionIndex, (pathAction, actionName) =>
        messageSchemas[actionName] = @generateMessageSchema actionName, pathAction

    messageSchemas

  generateMessageSchema: (actionName, pathAction) =>
    messageSchema =
      $schema: "http://json-schema.org/draft-04/schema#"
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

    parameters = @getParametersForAction(actionName, @swagger)
    messageSchema.properties.options.properties = @getPropertiesFromParameters parameters

    messageSchema



module.exports = Swagger2ToMessageSchema
