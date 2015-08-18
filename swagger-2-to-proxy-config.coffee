_ = require 'lodash'

class Swagger2ToProxyConfig

  generateProxyConfig: (path, method, swaggerConfig={})=>
    newPath = '"' + path.replace(/{/g, '#{options.') + '"'

    proxyConfig =
      uri: newPath
      method: method.toUpperCase()

    bodyParams = @getBodyParams swaggerConfig
    proxyConfig.body = bodyParams if bodyParams?

    proxyConfig

  getBodyParams: (swaggerConfig) =>
    newBodyParams = {}
    bodyParams = swaggerConfig.parameters
    _.each bodyParams, (bodyParam) =>
      # newBodyParam[].push bodyParam

    console.log JSON.stringify newBodyParams, null, 2
    newBodyParams

  generateBaseUrl: =>


module.exports = Swagger2ToProxyConfig
