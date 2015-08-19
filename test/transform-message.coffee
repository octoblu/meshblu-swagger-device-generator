_ = require 'lodash'
SwaggerPropertyNormalizer = require '../swagger-property-normalizer'
swagger = require './swagger/pets-resolved-badparamnames.json'

class ParameterMapper extends SwaggerPropertyNormalizer
  go: =>
    map = @getProxyConfig()
    console.log map

  getProxyConfig: =>
    @getActionParametersMap()

  getActionParametersMap: =>
    paramMap = {}
    _.each @getActions(), (action)=>
      paramMap[action] = @getActionParameterMap action

    paramMap

  getActionParameterMap: (action) =>
    params = _.compact _.map @getParametersForAction(action), @mapParam

    console.log params

  mapParam: (param) =>
    paramMap = {}
    oldName = param.name
    newName = @getParameterName param.name
    paramMap[oldName] = newName if oldName != newName
    _.extend(paramMap, @mapParam(param.parameters)) if param.parameters?
    _.extend(paramMap, @mapSchema(param.schema)) if param.schema?

    paramMap

  mapSchema: (schema) =>
    properties = schema.properties
    properties = schema.allOf[0].properties if schema.allOf?
    @mapSchemaProperties properties

  mapSchemaProperties: (properties) =>
    propertyMap = {}
    _.each properties, (property, oldName) =>
      console.log oldName
      newName = @getParameterName oldName
      propertyMap[oldName] = newName if oldName != newName

    propertyMap


  _getActionParameterMap: =>
    parameterMap = {}
    _.each @swagger.paths, (pathConfig, pathName) =>
      pathParameterMap = @getParameterMap(pathConfig.parameters || [])
      _.each pathConfig, (methodConfig, methodName) =>
        return if methodName == 'parameters'
        actionName = @getActionName methodConfig.operationId
        parameterMap[actionName] =_.union pathParameterMap, @getParameterMap methodConfig.parameters

    parameterMap

  getParameterMap: (params) =>
    params
  findAllParams : (obj) =>
    paramMap = {}
    return unless _.isArray(obj) || _.isObject(obj)
    _.each obj, (value, key) =>
      oldName = key
      newName = @getParameterName key
      console.log(oldName, ':', newName) if oldName != newName
      _.extend paramMap, @findAllParams value

    paramMap

mapper = new ParameterMapper swagger

mapper.go()
