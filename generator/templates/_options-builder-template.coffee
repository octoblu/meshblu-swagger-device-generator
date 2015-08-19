class OptionsBuilder
  constructor: ->
<% _.each(requestOptions, function(requestOption, requestName){%>
  <%=requestName%>: (options, callback=->) =>
    messagePropertyMap =
      <%=requestOption.messageNameMap %>

    options =
      method: '<%=requestOption.method%>'
      uri: <%-requestOption.uri%>
      <% if(requestOption.qs){%>
      qs:
        <% _.each(requestOption.qs, function(messageName, queryName){%><%=queryName%>: <%=messageName%>
        <%});%>
      <%}%>
      <% if(requestOption.body){%>
      body:
        <% _.each(requestOption.body, function(messageName, bodyName){%><%=bodyName%>: <%=messageName%>
        <%});%>
      <%}%>

    callback null, options
<%});%>

module.exports = OptionsBuilder
