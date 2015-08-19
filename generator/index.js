var yeoman = require('yeoman-generator');
var _ = require('lodash');

module.exports = yeoman.generators.Base.extend({
  constructor: function() {
    yeoman.generators.Base.apply(this, arguments);
    this.argument('proxyConfigFile', {type: String, required: true});
  },
  writing: function() {
    var templateContext = {
      _ : _,
    };
    proxyConfig = require(this.proxyConfigFile);
    templateContext.requestOptions = proxyConfig.requestOptions
    console.log(JSON.stringify(proxyConfig, null, 2));
    this.template('_options-builder-template.coffee', 'options-builder.coffee', templateContext);
  }
});
