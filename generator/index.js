var yeoman = require('yeoman-generator');
var _ = require('lodash');

module.exports = yeoman.generators.Base.extend({
  constructor: function() {
    yeoman.generators.Base.apply(this, arguments);
    this.argument('proxyConfigFile', {type: String, required: true});
  },
  writing: function() {
    var proxyConfig = require(this.proxyConfigFile);
    var templateContext = {
      _ : _,
      requestOptions : proxyConfig.requestOptions      
    };

    this.template('_options-builder-template.coffee', 'options-builder.coffee', templateContext);
  }
});
