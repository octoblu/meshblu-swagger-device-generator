_ = require 'lodash'
SwaggerPropertyNormalizer = require './swagger-property-normalizer'

class Swagger2ToProxyConfig extends SwaggerPropertyNormalizer

  generateProxyActionConfig: (actionName)=>
    proxyConfig =
      uri:    '"'  + @getUrlForAction(actionName) + '"'
      method: @methodByAction[actionName]
      body:   @getBodyParamsMap actionName
      qs:     @getQueryParamsMap actionName

  getQueryParamsMap: (actionName) =>
    parameters = @getParametersForAction actionName
    queryParams = _.filter parameters, in: 'query'
    return unless queryParams.length > 0
    @getParamMap queryParams

  getParamMap: (params) =>
    paramMap = {}
    _.each params, (param) =>
      paramMap[param.name] = "options.#{@getParameterName param.name}"

    paramMap

  getUrlForAction: (actionName) =>
    methodConfig = @actionIndex[actionName]
    path = @getBaseUrl() + @pathByAction[actionName]

    path.replace /{/g, '#{options.'


  getBodyParamsMap: (actionName) =>
    parameters = @getParametersForAction actionName
    bodyParameters = _.findWhere parameters, in: 'body'
    return unless bodyParameters?
    bodyParameters

  getParameterNameMap: (actionName) =>
    parameterNameMap = {}
    parameters = @getParametersForAction actionName
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
        console.log 'value is', value
        _.extend parameterNameMap, @getParameterNameMapFromObject value

    parameterNameMap

module.exports = Swagger2ToProxyConfig
