_ = require 'lodash'

class OptionsBuilder<% _.each(requestOptions, function(requestOption, requestName){%>
  <%=requestName%>: (options, callback=->) =><% if(requestOption.messagePropertyMap){%>
      messagePropertyMap = <% _.each(requestOption.messagePropertyMap, function(messageName, requestName){%>
        '<%=messageName%>' : '<%=requestName%>'<%});%>

      options = @convertMessageNames options, messagePropertyMap
  <%}%>
      requestOptions =
        uri: <%-requestOption.uri %>
        method:"<%=requestOption.method %>"<% if(requestOption.body && requestOption.body.length > 0){%>
        body:<% _.each(requestOption.body, function(bodyParam){%>
          '<%-bodyParam%>' : options['<%-bodyParam%>']<%});}%><% if(requestOption.qs && requestOption.qs.length > 0){%>
        qs:<% _.each(requestOption.qs, function(qsParam){%>
          '<%-qsParam%>' : options['<%-qsParam%>']<%});}%>


      callback null, requestOptions
<%});%>
  #this function is for the generator only. Not necessary for hand crafted, bespoke channels
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
