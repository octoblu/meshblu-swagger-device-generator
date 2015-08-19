_ = require 'lodash'
jq = require 'json-query'
SwaggerPropertyNormalizer = require '../swagger-property-normalizer'
swagger = require './swagger/pets-resolved.json'

class ParameterMapper extends SwaggerPropertyNormalizer
  go: =>
    @findAllParams @swagger

  findAllParams : (obj) =>
    paramMap = {}
    return unless _.isArray(obj) || _.isObject(obj)
    _.each obj, (value, key) =>
      @mapParameters(value) if key == 'parameters'
      _.extend paramMap, @findAllParams value

    paramMap


  mapParameters : (parameters) =>
    paramMap = {}    
    _.each parameters, (parameter) =>
      oldName = parameter.name
      newName = @getParameterName parameter.name
      console.log(oldName, ':', newName) if oldName != newName


mapper = new ParameterMapper swagger

mapper.go()
