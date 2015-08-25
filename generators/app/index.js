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
    this.composeWith('meshblu-connector', { coffee: true }, {
      local: require.resolve('generator-meshblu-connector'),
      link: 'strong'
    });
  },

  prompting: function () {
    var self = this;
    var done = self.async();

    self.log(yosay(
      'Welcome to the Meshblu Swagger Device generator!'
    ));

    var finishPrompting = function(error, proxyConfig){
      self.proxyConfig = proxyConfig;

      if(error) {
        return done(error);
      }

      if(!self.swaggerFile) {
        return done();
      }

      SwaggerDeviceGenerator.generateMessageSchema(self.swaggerFile, function(error, messageSchema){
        self.messageSchema = messageSchema;
        done(error);
      });

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
      requestOptions : self.proxyConfig.requestOptions
    };

    self.template('_options-builder-template.coffee', 'options-builder.coffee', templateContext);

    if(self.messageSchema) {
      var done = self.async();
        fs.writeFile('message-schema.json', JSON.stringify(self.messageSchema, null, 2), done);
    }

  }
});
