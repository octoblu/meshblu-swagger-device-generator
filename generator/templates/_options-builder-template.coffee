class OptionsBuilder
  constructor: ->
<% _.each(requestOptions, function(requestOption, requestName){%>
  <%=requestName%>: (options, callback=->) =>
    <% if(requestOption.messagePropertyMap){%>
    messagePropertyMap =
        <%=requestOption.messagePropertyMap %>
    @convertMessageNames propertyMessageMap
    <%}%>
    callback null, options
<%});%>

  convertMessageNames: (messagePropertyMap) =>
    console.log 'hello!'

module.exports = OptionsBuilder
