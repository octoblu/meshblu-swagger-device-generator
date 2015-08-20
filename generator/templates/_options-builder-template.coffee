_ = require 'lodash'
class OptionsBuilder
  constructor: ->

<% _.each(requestOptions, function(requestOption, requestName){%>
  <%=requestName%>: (options, callback=->) =>
    callback null, options

  convert<%=changeCase.upperCaseFirst(requestName)%>Message: (options)=>
    requestMessage = {}
    <% if(requestOption.messagePropertyMap){%>
    messagePropertyMap =<% _.each(requestOption.messagePropertyMap, function(messageName, requestName){%>
      '<%=messageName%>' : '<%=requestName%>'<%})%>

    options = @convertMessageNames options, messagePropertyMap
    <%}%><% if(requestOption.body){%>
    requestMessage.body = @getBodyParams options, requestOption.body
    <%}%><% if(requestOption.qs){%>
    requestMessage.qs = @getQueryParams options, requestOption.qs
    <%}%>
    requestMessage
<%});%>

  convertMessageNames: (options, messagePropertyMap) =>
    _.transform options, (message, value, name) =>
      name = messagePropertyMap[name] if messagePropertyMap[name]?
      if _.isArray value
        message[name] = _.map value, @convertMessageNames
        return true

      if _.isObject value
        message[name] = @convertMessageNames value
        return true

      message[name] = value
      true

module.exports = OptionsBuilder
