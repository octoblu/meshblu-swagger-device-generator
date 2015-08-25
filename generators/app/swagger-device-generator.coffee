fs = require 'fs'
path = require 'path'
SwaggerTransformer = require '../../parser/swagger-transformer'

class SwaggerDeviceGenerator
  @loadProxyConfig: (proxyConfigPath, callback=->) ->
    fs.readFile path.resolve(proxyConfigPath), 'utf8', (error, file) ->
      return callback error if error?

      try
       callback null, JSON.parse file
      catch error
        callback error

  @loadProxyConfigFromSwagger: (swaggerFilePath, callback=->) ->
    transformer = new SwaggerTransformer()
    transformer.toProxyConfig swaggerFilePath, callback

module.exports = SwaggerDeviceGenerator
