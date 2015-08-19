_ = require 'lodash'
Swagger2ToProxyConfig = require '../swagger-2-to-proxy-config'
describe 'Swagger2ToProxyConfig', ->
  beforeEach ->
    @petsSwagger = require './swagger/pets-resolved.json'
    @sut = new Swagger2ToProxyConfig @petsSwagger

  it 'should exist', ->
    expect(@sut).to.exist

  describe '.generateProxyActionConfig', ->
    it 'should exist', ->
      expect(@sut.generateProxyActionConfig).to.exist

    describe 'when called with an action name', ->
      beforeEach ->
        @result = @sut.generateProxyActionConfig 'getPetById'

      it 'should return the proxy config uri', ->
        expect(@result.uri).to.equal '\"http://petstore.swagger.wordnik.com/api/pets/#{options.id}\"'

      it 'should return the method', ->
        expect(@result.method).to.equal 'GET'

      it 'should not return body params', ->
        expect(@result.body).to.not.exist

    describe 'when called with an action name with query params', ->
      beforeEach ->
        @petsSwagger.paths['/pets'].get.parameters = [
          { name: "pet_status", in: "query"}
          { name: "pet_name", in: "query"}
        ]

        @result = @sut.generateProxyActionConfig 'getAllPets'

      it 'should return a proxy config with query parameters', ->
        expect(@result.qs).to.exist

      it 'should return a proxy config with query parameters that map to message properties', ->
        messagePropertyMap =
          pet_status: "options.petStatus"
          pet_name: "options.petName"

        expect(@result.qs).to.deep.equal messagePropertyMap


    describe 'when called with an action name with post data', ->
      beforeEach ->
        @petsSwagger.paths['/pets'].post.parameters = [
          { name: "pet_status", in: "query"}
          { name: "pet_name", in: "query"}
        ]
        @result = @sut.generateProxyActionConfig 'createPet'

      it 'should return a proxy config with body parameters', ->
        expect(@result.body).to.exist

      it 'should return a proxy config with body parameters that map to message properties', ->
        messagePropertyMap =
          monster_type: "options.monsterType"
          monster_name: "options.monsterName"

        expect(@result.body).to.equal messagePropertyMap
