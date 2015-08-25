require('coffee-script/register');
var yeoman = require('yeoman-generator');
var _ = require('lodash');
var yosay = require('yosay');
var changeCase = require('change-case');
var SwaggerTransformer = require('../../parser/swagger-transformer');

module.exports = yeoman.generators.Base.extend({
  constructor: function() {
    yeoman.generators.Base.apply(this, arguments);
    this.argument('proxyConfigFile', {type: String, required: false});
  },

  prompting: function () {
    var done = this.async();

    this.log(yosay(
      'Welcome to the Meshblu Swagger Device generator!'
    ));

    var prompts = [
      {
        name: 'swaggerFile',
        message: 'Where is your swagger file?'
      },
      {
          name: 'proxyConfigFile',
          message: 'Where is your proxy config file?'
      }
    ];

    this.prompt(prompts, function (props) {

      if(props.swaggerFile) {
        var transformer = new SwaggerTransformer();
        var self = this;
        return transformer.toProxyConfig(props.swaggerFile, function(error, proxyConfig){
            console.log('hi from the swagger file parser!');
            console.log('error:', error);
            console.log(JSON.stringify(proxyConfig, null, 2));
            self.proxyConfig = proxyConfig;
            done();
          });
      }

      if(props.proxyConfigFile) {
          this.proxyConfig = require(props.proxyConfigFile);
          done();
      }

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

function generateProxyConfig(swaggerFile, done){
  console.log(arguments);
  done()
}
