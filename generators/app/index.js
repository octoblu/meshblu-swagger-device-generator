require('coffee-script/register');
var fs = require('fs');
var path = require('path');

var yeoman = require('yeoman-generator');
var _ = require('lodash');
var yosay = require('yosay');
var SwaggerDeviceGenerator = require('./swagger-device-generator');

module.exports = yeoman.generators.Base.extend({
  constructor: function() {
    yeoman.generators.Base.apply(this, arguments);
  },

  prompting: function () {
    var self = this;
    var done = self.async();

    self.log(yosay(
      'Welcome to the Meshblu Swagger Device generator!'
    ));

    var finishPrompting = function(error, proxyConfig){
      if(error) {
        return done(error);
      }
      self.proxyConfig = proxyConfig
      done();
    };

    if(self.options.proxyConfig) {
      return SwaggerDeviceGenerator.loadProxyConfig(self.options.proxyConfig, finishPrompting);
    }

    if(self.options.swagger) {
      return SwaggerDeviceGenerator.loadProxyConfigFromSwagger(self.options.swagger, finishPrompting);
    }

    self.prompt({
      name: 'swaggerFile',
      message: 'Where is your swagger file?'
    }, function (answers) {
      SwaggerDeviceGenerator.loadProxyConfigFromSwagger(answers.swaggerFile, finishPrompting);
    });
    
  },

  writing: function() {
    proxyConfig = this.proxyConfig;
    var templateContext = {
      _ : _,
      requestOptions : proxyConfig.requestOptions
    };

    this.template('_options-builder-template.coffee', 'options-builder.coffee', templateContext);
  }
});
