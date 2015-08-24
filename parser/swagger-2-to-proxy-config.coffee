_ = require 'lodash'
SwaggerPropertyNormalizer = require './swagger-property-normalizer'

class Swagger2ToProxyConfig extends SwaggerPropertyNormalizer

  generateProxyActionConfig: (actionName)=>
    messagePropertyMap = _.extend {}, @getBodyParamsMap(actionName), @getQueryParamsMap(actionName)
    proxyConfig =
      uri:    '"'  + @getUrlForAction(actionName) + '"'
      messagePropertyMap: messagePropertyMap
      method: @methodByAction[actionName]
      qs: @getQueryParams actionName
      body: @getBodyParams actionName

  getQueryParams: (actionName) =>
    parameters = @getParametersForAction actionName
    _.pluck _.filter(parameters, in: 'query'), 'name'

  getBodyParams: (actionName) =>
    parameters = @getParametersForAction actionName
    _.pluck _.filter(parameters, in: 'body'), 'name'

  getQueryParamsMap: (actionName) =>
    parameters = @getParametersForAction actionName
    queryParams = _.filter parameters, in: 'query'
    return unless queryParams.length > 0
    @getParamMap queryParams

  getBodyParamsMap: (actionName) =>
    parameters = @getParametersForAction actionName
    bodyParams = _.filter parameters, in: 'body'
    return unless bodyParams.length > 0
    @getParamMap bodyParams


  getParamMap: (params) =>
    paramMap = {}
    _.each params, (param) =>
      paramMap[param.name] = @getParameterName param.name

    paramMap

  getUrlForAction: (actionName) =>
    methodConfig = @actionIndex[actionName]
    path = @getBaseUrl() + @pathByAction[actionName]

    path.replace /{/g, '#{options.'

  getParameterNameMap: (parameters) =>
    parameterNameMap = {}
    _.each parameters, (parameter) =>
      messageName = @getParameterName parameter.name
      parameterNameMap[messageName] = parameter.name if messageName != parameter.name

      if parameter.schema?
        _.extend parameterNameMap, @getParameterNameMapFromObject parameter.schema

    parameterNameMap

  getParameterNameMapFromObject: (schema) =>
    parameterNameMap = {}
    _.each schema, (value, parameterName) =>
      messageName = @getParameterName parameterName
      parameterNameMap[messageName] = parameterName if messageName != parameterName

      if _.isObject value
        _.extend parameterNameMap, @getParameterNameMapFromObject value

    parameterNameMap

  getParameterTypeMap: (parameters) =>
    parameterTypeMap = {}

    queryParams = _.filter parameters, in: 'query'
    bodyParam = _.find parameters, in: 'body'

    parameterTypeMap.qs = _.pluck queryParams, 'name' if queryParams.length

    properties = bodyParam.schema.properties || bodyParam.schema.allOf?[0]?.properties

    parameterTypeMap.body = _.keys properties

    parameterTypeMap

module.exports = Swagger2ToProxyConfig
