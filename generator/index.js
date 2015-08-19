yeoman = require('yeoman-generator');

module.exports = yeoman.generators.Base.extend({
  constructor: function() {
    yeoman.generators.Base.apply(this, arguments);
    this.argument('proxyConfigFile', {type: String, required: true});
  },
  writing: function() {
    proxyConfig = require(this.proxyConfigFile);
    console.log(JSON.stringify(proxyConfig, null, 2));
    this.template('_options-builder-template.coffee', 'options-builder.coffee', proxyConfig);
  }
});
