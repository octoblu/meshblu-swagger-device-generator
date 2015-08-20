_ = require 'lodash'

class OptionsBuilder<% _.each(requestOptions, function(requestOption, requestName){%>
  <%=requestName%>: (options, callback=->) =>
    @convert<%=changeCase.upperCaseFirst(requestName)%>Message: (options, callback=->) =><% if(requestOption.messagePropertyMap){%>
      messagePropertyMap = <% _.each(requestOption.messagePropertyMap, function(messageName, requestName){%>
        '<%=messageName%>' : '<%=requestName%>'<%});%>

      options = @convertMessageNames options, messagePropertyMap
  <%}%>
      requestOptions = <% if(requestOption.body){%>
        body:<% _.each(requestOption.body, function(bodyParam){%>
          '<%-bodyParam%>' : options['<%-bodyParam%>']<%});%>
  <%}%>
    callback null, requestOptions
<%});%>
  @convertMessageNames: (options, messagePropertyMap) =>
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
