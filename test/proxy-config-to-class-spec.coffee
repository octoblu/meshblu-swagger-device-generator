_ = require 'lodash'
ProxyConfigToClass = require '../proxy-config-to-class'
{Class, Code} = require 'coffee-script/lib/coffee-script/nodes'
petSchema = require './message-schema/pet-store-message-schema.json'
fs = require 'fs'
describe.only 'ProxyConfigToClass', ->
  it 'should exist', ->
    expect(ProxyConfigToClass).to.exist
  beforeEach ->
    @sut = new ProxyConfigToClass
  
  describe 'transform', ->
    describe 'when called with the pet schema', ->
      beforeEach ->
        @result = @sut.transform petSchema
      it 'should return a string', ->
        fs.writeFileSync 'compiled.js', @result
        expect(@result).to.be.a 'string'
        
  describe 'generateAst', ->
    describe 'when called with the pet schema', ->
      beforeEach ->        
        @result = @sut.generateAst petSchema
        
      it 'should return a Class object', ->
        expect(@result).to.be.an.instanceof Class
      
      it 'should return a Class object with all of the petSchema functions', ->
        expect(@result.body.expressions.length).to.equal 4        
  
    describe 'generateFunction', ->
      
      describe 'when called with the getAllPets config', ->      
        beforeEach ->        
          @result = @sut.generateFunction petSchema.getAllPets
          
        it 'should return a Class object', ->
          expect(@result).to.be.an.instanceof Code