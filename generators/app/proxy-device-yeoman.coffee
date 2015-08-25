yeoman = require 'yeoman-generator'

class ProxyDeviceYeoman extends yeoman.generators.Base
  writeApp: (view) =>
    @template('_options-builder-template.coffee', 'options-builder.coffee', view)


module.exports = ProxyDeviceYeoman
