_ = require 'lodash'
class MessageToParameter
  constructor: (@parameterNameMap) ->

  getParameter: (message) =>
    _.transform message, (parameter, value, name) =>
      name = @parameterNameMap[name] if @parameterNameMap[name]?            
      if _.isArray value
        parameter[name] = _.map value, @getParameter
        return true

      if _.isObject value
        parameter[name] = @getParameter value
        return true

      parameter[name] = value
      true

module.exports = MessageToParameter
