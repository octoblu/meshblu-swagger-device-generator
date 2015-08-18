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
    bodyParams = swaggerConfig.parameters

    bodyParams

module.exports = Swagger2ToProxyConfig
