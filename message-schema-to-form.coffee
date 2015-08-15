_ = require 'lodash'

class MessageSchemaToForm
  init: (callback=->)=>
    _.defer callback

  transform: (messageSchemas) =>
    form = {}
    _.each messageSchemas, (messageSchema, schemaName) =>
      return if schemaName == 'title'            
      form[schemaName] = @getForm messageSchema.properties?.options    
    
    form

  getForm: (messageOptions) =>        
    _.map messageOptions.properties, (property, propertyName) =>
      @getFormForAction propertyName, property

  getFormForAction: (name, action) =>    
    actionPropertyForm =
      key: "options.#{name}"          
    actionPropertyForm


module.exports = MessageSchemaToForm