_ = require 'lodash'

class MessageSchemaToForm
  init: (callback=->)=>
    _.defer callback

  transform: (messageSchema) =>
    @getForm messageSchema.properties

  getSubschemaTitleMap: (properties) =>
    _.map properties.subschema.enum, (action) =>
      action = value: action, name: properties[action].description

  getForm: (properties) =>    
    form = [
      key: 'subschema'
      title: 'Action'
      titleMap: @getSubschemaTitleMap properties
    ]
    _.each properties.subschema.enum, (action) =>
      form = form.concat(@getFormForAction action, properties[action])

    form

  getFormForAction: (name, action) =>
    actionForm = [
      key: name
      notitle: true
      type: 'hidden'
    ]
    actionForm.concat _.map action.properties, (actionProperty, actionPropertyName) =>
      actionPropertyForm =
        key: "#{name}.#{actionPropertyName}"
        condition: "model.subschema === '#{name}'"

      actionPropertyForm.title = actionProperty.description if actionProperty.description?
      actionPropertyForm


module.exports = MessageSchemaToForm

#for reference - delete
class ChannelToForm
  transform: (channel) =>
    return [] unless channel?
    @getForm channel?.application?.resources

  getForm: (resources) =>
    form = [
      key: 'subschema'
      title: 'Action'
      titleMap: @getSubschemaTitleMap resources
    ]

    resourceForms = _.flatten( _.map resources, @getFormFromResource )

    form.concat resourceForms

  getFormFromResource: (resource) =>
    form = [
      key: "#{resource.action}"
      notitle: true
      type: 'hidden'
    ]

    _.each resource.params, (param) =>
      form.push(@getFormFromParam resource.action, param)

    form

  getFormFromParam: (action, param) =>
    formParam =
      key: "#{action}.#{@sanitizeParam param.name}"
      title: param.displayName
      condition: "model.subschema === '#{action}'"
      required: param.required

    if param.hidden?
      formParam.type = 'hidden'
      formParam.notitle = true

    formParam

  getSubschemaTitleMap: (resources) =>
    _.map resources, (resource) =>
      value: resource.action, name: resource.displayName

  convertFormParam: (param, url, method) =>
    formParam =
      key: "#{@sanitizeParam param.name}"
      title: param.displayName
      condition: "model.url === '#{url}' && model.method === '#{method}'"

    if param.hidden?
      formParam.type = 'hidden'
      formParam.notitle = true

    formParam

  sanitizeParam: (param) =>
    param.replace(/^:/, '')