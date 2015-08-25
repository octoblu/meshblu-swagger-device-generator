require('coffee-script/register');
var fs = require('fs');
var path = require('path');

var yeoman = require('yeoman-generator');
var _ = require('lodash');
var yosay = require('yosay');
var changeCase = require('change-case');
var SwaggerTransformer = require('../../parser/swagger-transformer');


module.exports = yeoman.generators.Base.extend({
  constructor: function() {
    yeoman.generators.Base.apply(this, arguments);
  },

  prompting: function () {
    var self = this;
    var done = this.async();

    this.log(yosay(
      'Welcome to the Meshblu Swagger Device generator!'
    ));

    if(this.options.proxyConfig) {
      console.log(this.options.proxyConfig);
      fs.readFile( path.resolve(this.options.proxyConfig), 'utf8', function(error, file){
        if(error) {
          return done(error);
        }
        try {
          self.proxyConfig = JSON.parse(file);
        } catch(error) {
          done(error);
        }
        done();
      });

      return;
    }

    var prompts = [];
    prompts.push({
        name: 'swaggerFile',
        message: 'Where is your swagger file?'
    });

    this.prompt(prompts, function (props) {
        var transformer = new SwaggerTransformer();        
        return transformer.toProxyConfig(props.swaggerFile, function(error, proxyConfig){
            self.proxyConfig = proxyConfig;
            done();
          });
    }.bind(this));
  },

  writing: function() {
    proxyConfig = this.proxyConfig;
    var templateContext = {
      _ : _,
      requestOptions : proxyConfig.requestOptions,
      changeCase: changeCase
    };

    this.template('_options-builder-template.coffee', 'options-builder.coffee', templateContext);
  }
});
