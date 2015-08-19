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
    console.log bodyParameters
    bodyParameters

module.exports = Swagger2ToProxyConfig
