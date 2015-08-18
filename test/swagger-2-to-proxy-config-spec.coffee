_ = require 'lodash'
Swagger2ToProxyConfig = require '../swagger-2-to-proxy-config'
describe 'Swagger2ToProxyConfig', ->
  beforeEach ->
    @sut = new Swagger2ToProxyConfig()

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

    describe 'when called with a a swagger config with post data', ->
      beforeEach ->
        swaggerConfig =
          parameters: [
            name: "monster_type", in: "body"
            name: "monster_name", in: "body"
            name: "monster_id", in: "query"
          ]

        @result = @sut.generateProxyConfig(
          "petstore.swagger.wordnik.com/api/pets"
          "POST"
          swaggerConfig
        )

      it 'should return a proxy config with body parameters', ->
        expect(@result.body).to.exist

      xit 'should return a proxy config with body parameters that map to message properties', ->
        messagePropertyMap =
          monster_type: "monsterType"
          monster_name: "monsterName"

        expect(@result.body).to.equal messagePropertyMap
