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
    console.log JSON.stringify messagePropertyMap, null, 2

module.exports = OptionsBuilder
