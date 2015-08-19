_ = require 'lodash'
SwaggerPropertyNormalizer = require './swagger-property-normalizer'

class Swagger2ToProxyConfig extends SwaggerPropertyNormalizer

  generateProxyActionConfig: (actionName)=>
    proxyConfig =
      uri:    '"'  + @getUrlForAction(actionName) + '"'
      method: @methodByAction[actionName]

    bodyParamMap = @getBodyParamMap actionName

    proxyConfig.body = bodyParams if bodyParams?

    proxyConfig

  getUrlForAction: (actionName) =>
    methodConfig = @actionIndex[actionName]
    path = @getBaseUrl() + @pathByAction[actionName]

    path.replace /{/g, '#{options.'


  getBodyParamMap: (actionName) =>
    parameters = @getParametersForAction actionName
    bodyParameters = _.filter parameters, in: 'body'

module.exports = Swagger2ToProxyConfig
