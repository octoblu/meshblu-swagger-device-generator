_ = require 'lodash'
nodes = require 'coffee-script/lib/coffee-script/nodes'
{Class, Code, Block, Value, Assign, Literal, Obj} = nodes

class ProxyConfigToClass
  constructor: ->    
  transform: (proxyConfig)=>
    theClass = @generateAst proxyConfig
    console.log theClass.toString()
    theClass.compile()
  
  generateAst: (proxyConfig) =>
    functions = _.compact _.map proxyConfig, (config, name) =>
      return if name == 'title'
      @generateFunction name, config
    
    new Block [@generateClass functions]
    
  
  generateClass: (functions) =>
    functions.push new Literal 'theClass'
    proxyClassBody = 
      new Block([
          new Value new Literal 'theClass'
          new Value (
            new Obj functions        
        )
      ])    
    new Class proxyClassBody
    
  generateFunction: (name, config) =>
    params = @generateParam []
    fn = new Assign(
      new Value(new Literal name)
      new Code [], new Block, 'boundfunc'
    )    
    fn
  generateParam: () =>
        

module.exports = ProxyConfigToClass
    
