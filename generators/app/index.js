require('coffee-script/register');

var fs = require('fs');
var path = require('path');
var _ = require('lodash');

var yeoman = require('yeoman-generator');
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
      self.swaggerFile = self.options.swagger;
      return SwaggerDeviceGenerator.loadProxyConfigFromSwagger(self.options.swagger, finishPrompting);
    }

    self.prompt({
      name: 'swaggerFile',
      message: 'Where is your swagger file?'
    }, function (answers) {
      self.swaggerFile = answers.swaggerFile;
      SwaggerDeviceGenerator.loadProxyConfigFromSwagger(answers.swaggerFile, finishPrompting);
    });

  },

  writing: function() {
    var self = this;
    var templateContext = {
      _ : _,
      requestOptions : this.proxyConfig.requestOptions
    };

    this.template('_options-builder-template.coffee', 'options-builder.coffee', templateContext);
    console.log(self.swaggerFile);
    if(self.swaggerFile) {
      var done = self.async();
      SwaggerDeviceGenerator.generateMessageSchema(self.swaggerFile, function(error, messageSchema){
        console.log('generated message schema');
        if(error) {
          return done(error);
        }

        fs.writeFile('message-schema.json', JSON.stringify(messageSchema, null, 2), done);
      });
    }
  }
});
