var yeoman = require('yeoman-generator');
var _ = require('lodash');
var yosay = require('yosay');
var changeCase = require('change-case');

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
      this.proxyConfigFile = props.proxyConfigFile;
      generateProxyConfig(props.swaggerFile, done);
    }.bind(this));
  },

  writing: function() {
    var proxyConfig = require(this.proxyConfigFile);
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
