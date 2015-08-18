_ = require 'lodash'
Swagger2ToProxyConfig = require '../swagger-2-to-proxy-config'
describe 'Swagger2ToProxyConfig', ->
  beforeEach ->
    @petsSwagger = require './swagger/pets-resolved.json'
    @sut = new Swagger2ToProxyConfig()
    @sut.swagger = @petsSwagger

  it 'should exist', ->
    expect(@sut).to.exist

  describe '.generateProxyConfig', ->
    it 'should exist', ->
      expect(@sut.generateProxyConfig).to.exist

    describe 'when called with an action with swagger parameters', ->
      beforeEach ->
        @result = @sut.generateProxyConfig(
          "http://petstore.swagger.wordnik.com/api/pets/{id}"
          "get"
        )

      it 'should return the proxy config uri', ->
        expect(@result.uri).to.equal '\"http://petstore.swagger.wordnik.com/api/pets/#{options.id}\"'

      it 'should return the method', ->
        expect(@result.method).to.equal 'GET'

      it 'should not return body params', ->
        expect(@result.body).to.not.exist

    xdescribe 'when called with a a swagger config with post data', ->
      beforeEach ->
        swaggerConfig = @petsSwagger.paths['/pets'].post
        @result = @sut.generateProxyConfig(
          "petstore.swagger.wordnik.com/api/pets"
          "POST"
          swaggerConfig
        )

      it 'should return a proxy config with body parameters', ->
        expect(@result.body).to.exist

  describe '.generateBaseUrl', ->
    it 'should exist', ->
      expect(@sut.generateBaseUrl).to.exist

    describe 'when called with a swagger file containing an http scheme', ->
      beforeEach ->
        @sut.generateBaseUrl()
